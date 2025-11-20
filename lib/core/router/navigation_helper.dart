import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToLibrary(BuildContext context) {
    context.go('/library');
  }

  static void goToLearning(BuildContext context) {
    context.go('/learning');
  }

  static void goToHistory(BuildContext context) {
    context.go('/history');
  }

  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }

  static void goToCourseDetail(BuildContext context, String courseId) {
    context.push('/course/$courseId');
  }

  static void goToPdfReader(BuildContext context, String bookId, {int? page}) {
    final uri = Uri(
      path: '/pdf/$bookId',
      queryParameters: page != null ? {'page': page.toString()} : null,
    );
    context.push(uri.toString());
  }

  static void goToSignIn(BuildContext context) {
    context.go('/sign-in');
  }

  static void goToSignUp(BuildContext context) {
    context.go('/sign-up');
  }

  static void goToPhoneSignUp(BuildContext context) {
    context.push('/phone-sign-up');
  }

  static void goToOnboarding(BuildContext context) {
    context.go('/onboarding');
  }

  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  static void popUntilHome(BuildContext context) {
    while (context.canPop()) {
      context.pop();
    }
    context.go('/home');
  }

  static String getCurrentLocation(BuildContext context) {
    return GoRouterState.of(context).uri.path;
  }

  static Map<String, String> getQueryParameters(BuildContext context) {
    return GoRouterState.of(context).uri.queryParameters;
  }

  static Map<String, String> getPathParameters(BuildContext context) {
    return GoRouterState.of(context).pathParameters;
  }
}
