import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/app/theme/app_theme.dart';
import 'package:ahoruna/src/app/theme/theme_mode_provider.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';

class AhorunaApp extends ConsumerWidget {
  const AhorunaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
