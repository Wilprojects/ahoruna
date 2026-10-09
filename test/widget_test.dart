import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/app/app.dart';

void main() {
  testWidgets('renders Ahoruna design system screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AhorunaApp()));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Ahoruna'), findsOneWidget);

    expect(find.text('Tus finanzas, más simples'), findsOneWidget);

    expect(find.text('Apariencia'), findsOneWidget);

    expect(find.text('Acción principal'), findsOneWidget);
  });
}
