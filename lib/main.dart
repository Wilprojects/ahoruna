import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //Garantiza que el motor Flutter y los bindings necesarios están preparados

  runApp(
    const ProviderScope(
      //Contenedor raíz de Riverpod
      child: AhorunaApp(),
    ),
  );
}
