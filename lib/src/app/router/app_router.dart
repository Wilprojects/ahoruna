import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/router/auth_router_refresh.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/login_screen.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/register_screen.dart';
import 'package:ahoruna/src/features/home/presentation/screens/home_screen.dart';
import 'package:ahoruna/src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ahoruna/src/features/startup/presentation/screens/splash_screen.dart';
import 'package:ahoruna/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:ahoruna/src/features/settings/presentation/screens/appearance_screen.dart';
import 'package:ahoruna/src/features/settings/presentation/screens/security_screen.dart';
import 'package:ahoruna/src/features/settings/presentation/screens/settings_screen.dart';

import 'package:ahoruna/src/features/categories/presentation/screens/categories_screen.dart';
import 'package:ahoruna/src/features/categories/presentation/screens/category_form_screen.dart';

import 'package:ahoruna/src/features/transactions/presentation/screens/transaction_form_screen.dart';
import 'package:ahoruna/src/features/transactions/presentation/screens/transactions_screen.dart';

import 'package:ahoruna/src/features/budgets/presentation/screens/budget_form_screen.dart';
import 'package:ahoruna/src/features/budgets/presentation/screens/budgets_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  final refreshNotifier = AuthRouterRefresh(authRepository.userChanges());

  ref.onDispose(refreshNotifier.dispose);

  const publicRoutes = <String>{
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  };

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final isAuthenticated = authRepository.currentUser != null;

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      return null;
    },
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
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) {
          return const SettingsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.appearance,
        name: 'appearance',
        builder: (context, state) {
          return const AppearanceScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.security,
        name: 'security',
        builder: (context, state) {
          return const SecurityScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        builder: (context, state) {
          return const CategoriesScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.categoryCreate,
        name: 'categoryCreate',
        builder: (context, state) {
          return const CategoryFormScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.categoryEdit,
        name: 'categoryEdit',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;

          return CategoryFormScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: AppRoutes.transactions,
        name: 'transactions',
        builder: (context, state) {
          return const TransactionsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.transactionCreate,
        name: 'transactionCreate',
        builder: (context, state) {
          return const TransactionFormScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.transactionEdit,
        name: 'transactionEdit',
        builder: (context, state) {
          final transactionId = state.pathParameters['transactionId']!;

          return TransactionFormScreen(transactionId: transactionId);
        },
      ),
      GoRoute(
        path: AppRoutes.budgets,
        name: 'budgets',
        builder: (context, state) {
          return const BudgetsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.budgetCreate,
        name: 'budgetCreate',
        builder: (context, state) {
          return BudgetFormScreen(period: state.uri.queryParameters['period']);
        },
      ),
      GoRoute(
        path: AppRoutes.budgetEdit,
        name: 'budgetEdit',
        builder: (context, state) {
          final budgetId = state.pathParameters['budgetId']!;

          return BudgetFormScreen(budgetId: budgetId);
        },
      ),
    ],
  );
});
