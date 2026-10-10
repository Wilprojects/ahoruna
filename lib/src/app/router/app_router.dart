import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/login_screen.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/register_screen.dart';
import 'package:ahoruna/src/features/home/presentation/screens/home_screen.dart';
import 'package:ahoruna/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ahoruna/src/features/startup/presentation/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) {
        return const ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);
