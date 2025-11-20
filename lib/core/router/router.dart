import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/features/auth/view/phone_sign_up_screen.dart';
import 'package:codium/features/auth/view/sign_in_screen.dart';
import 'package:codium/features/auth/view/sign_up_screen.dart';
import 'package:codium/features/course_details/view/course_detail_screen.dart';
import 'package:codium/features/explanation_history/view/history_screen.dart';
import 'package:codium/features/learning/view/learning_screen.dart';
import 'package:codium/features/library/view/library_screen.dart';
import 'package:codium/features/main/view/main_screen.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:codium/features/onboarding/view/onboarding_screen.dart';
import 'package:codium/features/pdf_reader/view/pdf_reader_screen.dart';
import 'package:codium/features/profile/view/profile_screen.dart';
import 'package:codium/features/test/view/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static Future<bool> _checkOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  static bool _isAuthenticated(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticatedState;
  }

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) async {
      final isOnboardingComplete = await _checkOnboardingComplete();
      final isOnOnboardingPage = state.matchedLocation == '/onboarding';
      final isOnAuthPage =
          state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/sign-up' ||
          state.matchedLocation == '/phone-sign-up';

      if (!isOnboardingComplete && !isOnOnboardingPage) {
        return '/onboarding';
      }

      if (!context.mounted) return null;

      final isAuthenticated = _isAuthenticated(context);

      if (isOnboardingComplete && isOnOnboardingPage) {
        return isAuthenticated ? '/navigation' : '/sign-in';
      }

      if (!isAuthenticated && !isOnAuthPage && !isOnOnboardingPage) {
        return '/sign-in';
      }

      if (isAuthenticated && isOnAuthPage) {
        return '/navigation';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/navigation'),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const OnboardingScreen()),
      ),
      GoRoute(
        path: '/sign-up',
        name: 'sign-up',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignUpScreen()),
      ),
      GoRoute(
        path: '/phone-sign-up',
        name: 'phone-sign-up',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const PhoneSignUpScreen()),
      ),
      GoRoute(
        path: '/sign-in',
        name: 'sign-in',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const SignInScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: NavigationScreen(child: child));
        },
        routes: [
          GoRoute(
            path: '/navigation',
            name: 'navigation',
            redirect: (context, state) => '/home',
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const MainScreen()),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LibraryScreen(),
            ),
          ),
          GoRoute(
            path: '/learning',
            name: 'learning',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LearningScreen(),
            ),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HistoryScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/course/:courseId',
        name: 'course-detail',
        pageBuilder: (context, state) {
          final courseId = state.pathParameters['courseId']!;
          return MaterialPage(
            key: state.pageKey,
            child: CourseDetailScreen(courseId: courseId),
          );
        },
      ),
      GoRoute(
        path: '/pdf/:bookId',
        name: 'pdf-reader',
        pageBuilder: (context, state) {
          final bookId = state.pathParameters['bookId']!;
          final pageNumber = state.uri.queryParameters['page'];
          return MaterialPage(
            key: state.pageKey,
            child: PdfReaderScreen(
              bookId: bookId,
              initialPage: pageNumber != null ? int.tryParse(pageNumber) : null,
            ),
          );
        },
      ),
      GoRoute(
        path: '/test',
        name: 'test',
        pageBuilder: (context, state) =>
            MaterialPage(key: state.pageKey, child: const TestScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;
}
