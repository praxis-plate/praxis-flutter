import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/router/auth_notifier.dart';
import 'package:praxis/core/router/navigation_shell_initializer.dart';
import 'package:praxis/core/router/route_constants.dart';
import 'package:praxis/core/router/router_exports.dart';
import 'package:praxis/core/widgets/widgets.dart';
import 'package:praxis/features/auth/auth.dart';
import 'package:praxis/features/course_details/bloc/course_detail/course_detail_bloc.dart';
import 'package:praxis/features/course_details/view/course_detail_screen.dart';
import 'package:praxis/features/course_learning/view/course_learning_screen.dart';
import 'package:praxis/features/learning/learning.dart';
import 'package:praxis/features/main/main.dart';
import 'package:praxis/features/navigation/view/navigation_screen.dart';
import 'package:praxis/features/onboarding/view/onboarding_screen.dart';
import 'package:praxis/features/profile/profile.dart';
import 'package:praxis/features/tasks/view/lesson_task_session_screen.dart';
import 'package:praxis/features/tasks/view/task_screen.dart';
import 'package:praxis/s.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static const String _onboardingCompleteKey = 'onboarding_complete';
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
        return resolveRedirect(
          matchedLocation: state.matchedLocation,
          authState: _authNotifier.state,
          preferences: GetIt.I<SharedPreferences>(),
        );
      },
      routes: [
        GoRoute(
          path: RouteConstants.onboarding,
          name: 'onboarding',
          pageBuilder: (context, state) =>
              MaterialPage(key: state.pageKey, child: const OnboardingScreen()),
        ),
        GoRoute(
          path: RouteConstants.auth,
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
                  path: RouteConstants.navigation,
                  name: 'navigation',
                  redirect: (context, state) => RouteConstants.home,
                ),

                GoRoute(
                  path: RouteConstants.home,
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
                  path: RouteConstants.learning,
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
                  path: RouteConstants.profile,
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
                final s = S.of(context);
                return MaterialPage(
                  key: state.pageKey,
                  child: Scaffold(
                    body: Center(child: Text(s.lessonComingSoon)),
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

  static String? resolveRedirect({
    required String matchedLocation,
    required AuthState authState,
    required SharedPreferences preferences,
  }) {
    final isOnboardingComplete =
        preferences.getBool(_onboardingCompleteKey) ?? false;
    final isAuthRoute =
        matchedLocation.startsWith(RouteConstants.auth) ||
        matchedLocation == RouteConstants.phoneSignUp;
    final isOnboardingRoute = matchedLocation == RouteConstants.onboarding;
    final isRootRoute = matchedLocation == RouteConstants.root;

    if (!isOnboardingComplete && !isOnboardingRoute) {
      return RouteConstants.onboarding;
    }

    if (isOnboardingComplete && isOnboardingRoute) {
      return authState is AuthAuthenticatedState
          ? RouteConstants.navigation
          : RouteConstants.signIn;
    }

    if (authState is AuthUnauthenticatedState &&
        !isAuthRoute &&
        !isRootRoute &&
        !isOnboardingRoute) {
      return RouteConstants.signIn;
    }

    if (authState is AuthAuthenticatedState && (isAuthRoute || isRootRoute)) {
      return RouteConstants.navigation;
    }

    if (authState is AuthUnauthenticatedState && isRootRoute) {
      return RouteConstants.signIn;
    }

    return null;
  }
}
