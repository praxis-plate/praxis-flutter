import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/config/feature_flags.dart';
import 'package:codium/core/router/auth_notifier.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/auth.dart';
import 'package:codium/features/course_details/view/course_detail_screen.dart';
import 'package:codium/features/course_learning/view/course_learning_screen.dart';
import 'package:codium/features/explanation_history/view/history_screen.dart';
import 'package:codium/features/learning/view/learning_screen.dart';
import 'package:codium/features/library/view/library_screen.dart';
import 'package:codium/features/main/view/main_screen.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:codium/features/profile/view/profile_screen.dart';
import 'package:codium/features/tasks/view/lesson_task_session_screen.dart';
import 'package:codium/features/tasks/view/task_screen.dart';
import 'package:codium/features/test/view/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static late final AuthNotifier _authNotifier;
  static late final GoRouter _router;
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  static GoRouter get router => _router;

  static GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;
  static GlobalKey<NavigatorState> get shellNavigatorKey => _shellNavigatorKey;

  static void initialize() {
    _authNotifier = AuthNotifier(GetIt.I<AuthBloc>());
    _router = _createRouter();
  }

  static GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: _authNotifier,
      redirect: (context, state) {
        final authState = _authNotifier.state;

        final isAuthRoute =
            state.matchedLocation.startsWith('/auth') ||
            state.matchedLocation == '/phone-sign-up';

        if (authState is AuthUnauthenticatedState && !isAuthRoute) {
          return '/auth/sign-in';
        }

        if (authState is AuthAuthenticatedState && isAuthRoute) {
          return '/navigation';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/auth',
          name: 'auth',
          pageBuilder: (context, state) {
            final modeParam = state.uri.queryParameters['mode'];
            final mode = AuthMode.fromParam(modeParam);
            return MaterialPage(
              key: state.pageKey,
              child: AuthScreen(initialMode: mode),
            );
          },
          routes: [
            GoRoute(
              path: 'sign-in',
              name: 'sign-in',
              redirect: (context, state) =>
                  '/auth?mode=${AuthMode.signIn.value}',
            ),
            GoRoute(
              path: 'sign-up',
              name: 'sign-up',
              redirect: (context, state) =>
                  '/auth?mode=${AuthMode.signUp.value}',
            ),
            GoRoute(
              path: 'forgot-password',
              name: 'forgot-password',
              redirect: (context, state) =>
                  '/auth?mode=${AuthMode.forgotPassword.value}',
            ),
          ],
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) {
            final authState = GetIt.I<AuthBloc>().state;

            assert(
              authState is AuthAuthenticatedState,
              'Cannot access User: expected AuthAuthenticatedState, got ${authState.runtimeType}',
            );

            return NoTransitionPage(
              child: UserScope(
                user: (authState as AuthAuthenticatedState).user,
                child: NavigationScreen(child: child),
              ),
            );
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
                  child: const MainScreen(),
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
            if (FeatureFlags.enableProfile)
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
            final courseId = int.parse(state.pathParameters['courseId']!);
            return MaterialPage(
              key: state.pageKey,
              child: CourseDetailScreen(courseId: courseId),
            );
          },
        ),
        GoRoute(
          path: '/course/:courseId/learn',
          name: 'course-learning',
          pageBuilder: (context, state) {
            final courseId = int.parse(state.pathParameters['courseId']!);
            return MaterialPage(
              key: state.pageKey,
              child: CourseLearningScreen(courseId: courseId),
            );
          },
        ),
        GoRoute(
          path: '/lesson/:lessonId',
          name: 'lesson-content',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(child: Text('Lesson - Coming Soon')),
              ),
            );
          },
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'task',
          pageBuilder: (context, state) {
            final taskId = int.parse(state.pathParameters['taskId']!);
            return MaterialPage(
              key: state.pageKey,
              child: TaskScreen(taskId: taskId),
            );
          },
        ),
        GoRoute(
          path: '/lesson/:lessonId/tasks',
          name: 'lesson-task-session',
          pageBuilder: (context, state) {
            final lessonId = int.parse(state.pathParameters['lessonId']!);
            return MaterialPage(
              key: state.pageKey,
              child: LessonTaskSessionScreen(lessonId: lessonId, userId: 1),
            );
          },
        ),
        GoRoute(
          path: '/pdf/:bookId',
          name: 'pdf-reader',
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const Scaffold(
                body: Center(child: Text('PDF Reader - Coming Soon')),
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
  }
}
