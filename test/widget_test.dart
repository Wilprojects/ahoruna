import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/app.dart';

void main() {
  testWidgets('renders Ahoruna foundation screen', (tester) async {
    await tester.pumpWidget(
      //Crea nuestra aplicación dentro del entorno de pruebas
      const ProviderScope(child: AhorunaApp()),
    );

    await tester.pumpAndSettle(); //Espera a que terminen las reconstrucciones/animaciones pendientes

    expect(
      find.text('Ahoruna'),
      findsOneWidget,
    ); //Verifica una condición, se comprueba queaparezca 'Ahoruna'
    expect(
      find.text('Tus finanzas, más simples'), //Verifica una condición, se comprueba queaparezca 'Tus finanzas, más simples'
      findsOneWidget,
    );
  });
}
