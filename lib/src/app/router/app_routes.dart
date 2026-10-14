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

  static const String transactions = '/transactions';

  static const String transactionCreate = '/transactions/new';

  static const String transactionEdit = '/transactions/:transactionId/edit';

  static String transactionEditPath(String transactionId) {
    return '/transactions/$transactionId/edit';
  }
}
