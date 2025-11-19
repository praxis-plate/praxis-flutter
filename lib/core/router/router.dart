import 'package:codium/features/auth/view/sign_in_screen.dart';
import 'package:codium/features/auth/view/sign_up_screen.dart';
import 'package:codium/features/course_details/view/course_detail_screen.dart';
import 'package:codium/features/library/view/library_screen.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:codium/features/onboarding/view/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/navigation'),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/home', redirect: (context, state) => '/navigation'),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/navigation',
        builder: (context, state) => const NavigationScreen(),
      ),
      GoRoute(
        path: '/course/:courseId',
        builder: (context, state) =>
            CourseDetailScreen(courseId: state.pathParameters['courseId']!),
      ),
      GoRoute(
        path: '/test',
        builder: (context, state) => const LibraryScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
