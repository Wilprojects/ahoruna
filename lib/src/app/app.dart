import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/app/theme/app_theme.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';

class AhorunaApp extends StatelessWidget {
  const AhorunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
