import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:achadodocampus/home_page.dart';

void main() {
  testWidgets('dashboard mostra estatísticas e permite publicar item', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(userEmail: 'teste@email.com'),
      ),
    );

    expect(find.text('Estatísticas do\ncampus'), findsOneWidget);
    expect(find.text('74'), findsOneWidget);
    expect(find.text('52'), findsOneWidget);
    expect(find.text('70%'), findsOneWidget);
    expect(find.text('Distribuição dos itens perdidos'), findsOneWidget);

    await tester.tap(find.text('7d'));
    await tester.pumpAndSettle();
    expect(find.text('7d'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField),
      'Chave encontrada na biblioteca',
    );
    await tester.tap(find.text('Publicar item'));
    await tester.pumpAndSettle();

    expect(find.text('Chave encontrada na biblioteca'), findsOneWidget);
  });
}
