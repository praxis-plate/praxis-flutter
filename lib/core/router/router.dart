import 'package:codium/core/config/feature_flags.dart';
import 'package:codium/features/ai_explanation/bloc/ai_explanation_bloc.dart';
import 'package:codium/features/course_details/view/course_detail_screen.dart';
import 'package:codium/features/explanation_history/view/history_screen.dart';
import 'package:codium/features/library/view/library_screen.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:codium/features/pdf_reader/bloc/pdf_reader_bloc.dart';
import 'package:codium/features/pdf_reader/view/pdf_reader_screen.dart';
import 'package:codium/features/test/view/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/navigation'),
      if (FeatureFlags.enableOnboarding)
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Placeholder()),
        ),
      if (FeatureFlags.enableOnboarding)
        GoRoute(
          path: '/sign-up',
          name: 'sign-up',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Placeholder()),
        ),
      if (FeatureFlags.enableOnboarding)
        GoRoute(
          path: '/phone-sign-up',
          name: 'phone-sign-up',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Placeholder()),
        ),
      if (FeatureFlags.enableOnboarding)
        GoRoute(
          path: '/sign-in',
          name: 'sign-in',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const Placeholder()),
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
            redirect: (context, state) => '/library',
          ),
          if (FeatureFlags.enableCourses)
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const Placeholder(),
              ),
            ),
          GoRoute(
            path: '/library',
            name: 'library',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const LibraryScreen(),
            ),
          ),
          if (FeatureFlags.enableCourses)
            GoRoute(
              path: '/learning',
              name: 'learning',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const Placeholder(),
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
          if (FeatureFlags.enableProfile)
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const Placeholder(),
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
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => GetIt.I<PdfReaderBloc>()),
                BlocProvider(create: (context) => GetIt.I<AiExplanationBloc>()),
              ],
              child: PdfReaderScreen(
                bookId: bookId,
                initialPage: pageNumber != null
                    ? int.tryParse(pageNumber)
                    : null,
              ),
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
              onPressed: () => context.go('/library'),
              child: const Text('Go to Library'),
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
