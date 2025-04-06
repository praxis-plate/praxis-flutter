import 'package:codium/features/auth/view/signin_page.dart';
import 'package:codium/features/auth/view/signup_page.dart';
import 'package:codium/features/navigation/view/navigation_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _router = GoRouter(
    initialLocation: '/sign-up',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/navigation',
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => '/navigation',
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: '/navigation',
        builder: (context, state) => const NavigationScreen(),
      ),
    ],
  );

  static GoRouter get router => _router;
}
