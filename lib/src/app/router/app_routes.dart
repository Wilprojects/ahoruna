class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';

  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String appearance = '/settings/appearance';

  static const String security = '/settings/security';

  static const String categories = '/categories';

  static const String categoryCreate = '/categories/new';

  static const String categoryEdit = '/categories/:categoryId/edit';

  static String categoryEditPath(String categoryId) {
    return '/categories/$categoryId/edit';
  }
}
