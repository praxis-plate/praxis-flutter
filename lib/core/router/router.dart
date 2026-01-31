import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/router/auth_notifier.dart';
import 'package:codium/core/router/navigation_shell_initializer.dart';
import 'package:codium/core/router/router_exports.dart';
import 'package:codium/core/widgets/widgets.dart';
import 'package:codium/features/auth/auth.dart';
import 'package:codium/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:codium/features/course_details/view/course_detail_screen.dart';
import 'package:codium/features/course_learning/view/course_learning_screen.dart';
import 'package:codium/features/learning/learning.dart';
import 'package:codium/features/main/main.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:codium/features/profile/profile.dart';
import 'package:codium/features/tasks/view/lesson_task_session_screen.dart';
import 'package:codium/features/tasks/view/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

            final userProfile = (authState as AuthAuthenticatedState).user;

            return NoTransitionPage(
              child: UserScope(
                user: userProfile,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: GetIt.I<CoursePurchasingBloc>()),
                    BlocProvider.value(value: GetIt.I<UserStatisticsBloc>()),
                  ],
                  child: NavigationShellInitializer(child: child),
                ),
              ),
            );
          },
          routes: [
            ShellRoute(
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
                  pageBuilder: (context, state) {
                    final userProfile = UserScope.of(context, listen: false);

                    return NoTransitionPage(
                      key: state.pageKey,
                      child: BlocProvider<MainBloc>(
                        create: (context) => GetIt.I<MainBloc>()
                          ..add(MainLoadCoursesEvent(userId: userProfile.id)),
                        child: MainScreen(userProfile: userProfile),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/learning',
                  name: 'learning',
                  pageBuilder: (context, state) {
                    final userProfile = UserScope.of(context, listen: false);

                    return NoTransitionPage(
                      key: state.pageKey,
                      child: BlocProvider<LearningBloc>(
                        create: (_) =>
                            GetIt.I<LearningBloc>()
                              ..add(LearningLoadEvent(userId: userProfile.id)),
                        child: const LearningScreen(),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: '/profile',
                  name: 'profile',
                  pageBuilder: (context, state) {
                    final userProfile = UserScope.of(context, listen: false);

                    return NoTransitionPage(
                      key: state.pageKey,
                      child: ProfileScreen(userProfile: userProfile),
                    );
                  },
                ),
              ],
            ),

            GoRoute(
              path: '/course/:courseId',
              name: 'course-detail',
              pageBuilder: (context, state) {
                final courseId = int.parse(state.pathParameters['courseId']!);
                final userProfile = UserScope.of(context, listen: false);

                return MaterialPage(
                  key: state.pageKey,
                  child: BlocProvider(
                    create: (context) => GetIt.I<CourseDetailBloc>()
                      ..add(
                        CourseDetailLoadEvent(
                          courseId: courseId,
                          userId: userProfile.id,
                        ),
                      ),
                    child: CourseDetailScreen(
                      userProfile: userProfile,
                      courseId: courseId,
                    ),
                  ),
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
            // Lesson content page: shows the lesson material itself (reading/video).
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
            // Single task page: standalone task details and solving UI.
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
            // Lesson task session: step-by-step task flow for a specific lesson.
            GoRoute(
              path: '/lesson/:lessonId/tasks',
              name: 'lesson-task-session',
              pageBuilder: (context, state) {
                final lessonId = int.parse(state.pathParameters['lessonId']!);
                return MaterialPage(
                  key: state.pageKey,
                  child: LessonTaskSessionScreen(lessonId: lessonId),
                );
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: NotFoundScreen(
          path: state.uri.toString(),
          onNavigateHome: () => context.go(RouteConstants.home),
        ),
      ),
    );
  }
}
