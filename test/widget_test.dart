import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/theme/app_theme.dart';
import 'package:ahoruna/src/features/auth/presentation/screens/login_screen.dart';

void main() {
  testWidgets('renders login screen', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Bienvenido de nuevo'), findsOneWidget);

    expect(find.text('Correo electrónico'), findsOneWidget);

    expect(find.text('Contraseña'), findsOneWidget);

    expect(find.text('Iniciar sesión'), findsOneWidget);
  });
}
