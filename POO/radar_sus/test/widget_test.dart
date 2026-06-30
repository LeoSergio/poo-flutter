// test/widget_test.dart
// Teste de fumaça (smoke test) da aplicação
//
// Verifica apenas que o app inicializa sem erros — sem mockar a API.
// Para testes de integração com rede, use pacotes como mockito ou mocktail.
//
// Receita 7: em apps com programação assíncrona, o pumpAndSettle aguarda
// que todos os Futures e animações pendentes se resolvam antes dos expects.

import 'package:flutter_test/flutter_test.dart';
import 'package:radar_sus/main.dart';

void main() {
  testWidgets('App inicializa e renderiza sem lançar exceção',
      (WidgetTester tester) async {
    // Monta a raiz do app
    await tester.pumpWidget(const RadarSusApp());

    // Aguarda o primeiro frame — não faz pumpAndSettle para não depender
    // de rede; o estado AlertasCarregando já é suficiente para o smoke test
    await tester.pump();

    // Verifica que o widget raiz existe na árvore
    expect(find.byType(RadarSusApp), findsOneWidget);
  });
}
