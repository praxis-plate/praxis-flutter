class RouteConstants {
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String phoneSignUp = '/phone-sign-up';
  static const String navigation = '/navigation';
  static const String home = '/home';
  static const String library = '/library';
  static const String learning = '/learning';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String courseDetail = '/course/:courseId';
  static const String pdfReader = '/pdf/:bookId';
  static const String test = '/test';

  static String courseDetailPath(String courseId) => '/course/$courseId';
  static String pdfReaderPath(String bookId, {int? page}) {
    final uri = Uri(
      path: '/pdf/$bookId',
      queryParameters: page != null ? {'page': page.toString()} : null,
    );
    return uri.toString();
  }
}

class RouteNames {
  static const String onboarding = 'onboarding';
  static const String signIn = 'sign-in';
  static const String signUp = 'sign-up';
  static const String phoneSignUp = 'phone-sign-up';
  static const String navigation = 'navigation';
  static const String home = 'home';
  static const String library = 'library';
  static const String learning = 'learning';
  static const String history = 'history';
  static const String profile = 'profile';
  static const String courseDetail = 'course-detail';
  static const String pdfReader = 'pdf-reader';
  static const String test = 'test';
}
