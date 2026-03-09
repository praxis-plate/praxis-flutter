import 'package:codium/core/bloc/auth/auth_bloc.dart';
import 'package:codium/core/router/route_constants.dart';
import 'package:codium/core/router/router.dart';
import 'package:codium/domain/models/user/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppRouter.resolveRedirect', () {
    test('redirects first launch to onboarding from root', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      final redirect = AppRouter.resolveRedirect(
        matchedLocation: RouteConstants.root,
        authState: const AuthUnauthenticatedState(),
        preferences: preferences,
      );

      expect(redirect, RouteConstants.onboarding);
    });

    test('allows onboarding route on first launch', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();

      final redirect = AppRouter.resolveRedirect(
        matchedLocation: RouteConstants.onboarding,
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
          matchedLocation: RouteConstants.onboarding,
          authState: const AuthUnauthenticatedState(),
          preferences: preferences,
        );

        expect(redirect, RouteConstants.signIn);
      },
    );

    test('sends authenticated users away from auth and root', () async {
      SharedPreferences.setMockInitialValues({'onboarding_complete': true});
      final preferences = await SharedPreferences.getInstance();
      final authState = AuthAuthenticatedState(user: _user);

      final rootRedirect = AppRouter.resolveRedirect(
        matchedLocation: RouteConstants.root,
        authState: authState,
        preferences: preferences,
      );
      final authRedirect = AppRouter.resolveRedirect(
        matchedLocation: RouteConstants.signIn,
        authState: authState,
        preferences: preferences,
      );

      expect(rootRedirect, RouteConstants.navigation);
      expect(authRedirect, RouteConstants.navigation);
    });
  });
}

final _user = UserProfileModel(
  id: 'user-id',
  email: 'test@example.com',
  name: 'Test User',
  createdAt: DateTime(2026),
);
