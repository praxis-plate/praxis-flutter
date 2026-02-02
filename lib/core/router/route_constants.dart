class RouteConstants {
  static const String root = '/';
  static const String auth = '/auth';
  static const String signIn = '/auth/sign-in';
  static const String signUp = '/auth/sign-up';
  static const String forgotPassword = '/auth/forgot-password';
  static const String phoneSignUp = '/phone-sign-up';
  static const String navigation = '/navigation';
  static const String home = '/home';
  static const String learning = '/learning';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String courseDetail = '/course/:courseId';
  static const String test = '/test';

  static String courseDetailPath(String courseId) => '/course/$courseId';
}
