import 'package:flutter_test/flutter_test.dart';
import 'package:praxis/core/bloc/auth/auth_bloc.dart';
import 'package:praxis/core/router/router.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppRouter.resolveRedirect', () {
    test('redirects first launch to onboarding from root', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      final redirect = AppRouter.resolveRedirect(
        matchedLocation: '/',
        authState: const AuthUnauthenticatedState(),
        preferences: preferences,
      );

      expect(redirect, '/onboarding');
    });

    test('allows onboarding route on first launch', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      final redirect = AppRouter.resolveRedirect(
        matchedLocation: '/onboarding',
        authState: const AuthUnauthenticatedState(),
        preferences: preferences,
      );

      expect(redirect, isNull);
    });

    test(
      'sends completed onboarding users to sign in when unauthenticated',
      () async {
        SharedPreferences.setMockInitialValues({'onboarding_complete': true});
        final preferences = await SharedPreferences.getInstance();

        final redirect = AppRouter.resolveRedirect(
          matchedLocation: '/onboarding',
          authState: const AuthUnauthenticatedState(),
          preferences: preferences,
        );

        expect(redirect, '/auth/sign-in');
      },
    );

    test('sends authenticated users away from auth and root', () async {
      SharedPreferences.setMockInitialValues({'onboarding_complete': true});
      final preferences = await SharedPreferences.getInstance();
      final authState = AuthAuthenticatedState(
        user: UserProfileModel(
          id: 'user-id',
          email: 'test@example.com',
          name: 'Test User',
          createdAt: DateTime(2026),
        ),
      );

      final rootRedirect = AppRouter.resolveRedirect(
        matchedLocation: '/',
        authState: authState,
        preferences: preferences,
      );
      final authRedirect = AppRouter.resolveRedirect(
        matchedLocation: '/auth/sign-in',
        authState: authState,
        preferences: preferences,
      );

      expect(rootRedirect, '/navigation');
      expect(authRedirect, '/navigation');
    });
  });
}
