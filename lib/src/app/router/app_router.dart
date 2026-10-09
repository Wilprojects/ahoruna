import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/features/home/presentation/screens/home_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
