// test/models/alerta_dengue_test.dart
// Testes unitários do modelo AlertaDengue e ResumoDengue
//
// Receita 4: testa o factory fromJson — contrato entre a API e o modelo.
// Receitas 5/6: testa a lógica de negócio (ResumoDengue.calcular) isolada
// da UI, que é exatamente o benefício da separação de responsabilidades.

import 'package:flutter_test/flutter_test.dart';
import 'package:radar_sus/models/alerta_dengue.dart';

void main() {
  // ---------------------------------------------------------------------------
  // AlertaDengue.fromJson — Receita 4: parsing de objetos JSON
  // ---------------------------------------------------------------------------
  group('AlertaDengue.fromJson |', () {
    test('extrai corretamente os dados de um JSON válido', () {
      final jsonApi = {
        'SE': 202401,
        'casos': 15,
        'casos_est': 15.8, // double vindo da API — deve ser truncado para int
        'nivel': 2,
      };

      final alerta = AlertaDengue.fromJson(jsonApi);

      expect(alerta.semanaEpidemiologica, 202401);
      expect(alerta.casosNotificados, 15);
      expect(alerta.casosEstimados, 15); // truncado de 15.8
      expect(alerta.nivelAlerta, 2);
    });

    test('usa valores padrão quando o JSON está vazio', () {
      final alerta = AlertaDengue.fromJson({});

      expect(alerta.semanaEpidemiologica, 0);
      expect(alerta.casosNotificados, 0);
      expect(alerta.casosEstimados, 0);
      expect(alerta.nivelAlerta, 1); // nível mínimo como padrão seguro
    });

    test('aceita casos_est como inteiro sem erros', () {
      final jsonApi = {'SE': 202410, 'casos': 30, 'casos_est': 28, 'nivel': 3};
      final alerta = AlertaDengue.fromJson(jsonApi);
      expect(alerta.casosEstimados, 28);
    });
  });

  // ---------------------------------------------------------------------------
  // AlertaDengue — getters computados (semanaFormatada, periodoFormatado)
  // ---------------------------------------------------------------------------
  group('AlertaDengue getters computados |', () {
    test('formata a semana epidemiológica no padrão "Semana SS de AAAA"', () {
      final alerta = AlertaDengue(
        semanaEpidemiologica: 202412,
        casosNotificados: 0,
        casosEstimados: 0,
        nivelAlerta: 1,
      );

      expect(alerta.semanaFormatada, 'Semana 12 de 2024');
    });

    test('retorna a semana bruta quando o formato não tem 6 dígitos', () {
      final alerta = AlertaDengue(
        semanaEpidemiologica: 999,
        casosNotificados: 0,
        casosEstimados: 0,
        nivelAlerta: 1,
      );

      expect(alerta.semanaFormatada, '999');
    });

    test('periodoFormatado retorna intervalo dd/mm a dd/mm', () {
      final alerta = AlertaDengue(
        semanaEpidemiologica: 202401,
        casosNotificados: 0,
        casosEstimados: 0,
        nivelAlerta: 1,
      );

      // O período deve conter o padrão " a " indicando intervalo
      expect(alerta.periodoFormatado, contains(' a '));
    });
  });

  // ---------------------------------------------------------------------------
  // ResumoDengue.calcular — lógica de negócio isolada (Receita 6)
  // Testamos o "DataService" sem precisar de widgets ou API real
  // ---------------------------------------------------------------------------
  group('ResumoDengue.calcular |', () {
    test('retorna resumo vazio quando a lista de alertas está vazia', () {
      final resumo = ResumoDengue.calcular([]);

      expect(resumo.totalCasosAno, 0);
      expect(resumo.semanasPicoNivel, 0);
      expect(resumo.tendencia, TendenciaCasos.estavel);
      expect(resumo.ultimaSemana.nivelAlerta, 1);
    });

    test('identifica a última semana corretamente (maior SE)', () {
      final alertas = [
        AlertaDengue(
            semanaEpidemiologica: 202401,
            casosNotificados: 10,
            casosEstimados: 10,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202405,
            casosNotificados: 50,
            casosEstimados: 55,
            nivelAlerta: 3),
        AlertaDengue(
            semanaEpidemiologica: 202403,
            casosNotificados: 20,
            casosEstimados: 22,
            nivelAlerta: 2),
      ];

      final resumo = ResumoDengue.calcular(alertas);

      // A última semana deve ser a de maior SE (202405)
      expect(resumo.ultimaSemana.semanaEpidemiologica, 202405);
      expect(resumo.ultimaSemana.casosNotificados, 50);
    });

    test('soma corretamente o total de casos no ano', () {
      final alertas = [
        AlertaDengue(
            semanaEpidemiologica: 202401,
            casosNotificados: 10,
            casosEstimados: 10,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202402,
            casosNotificados: 25,
            casosEstimados: 28,
            nivelAlerta: 2),
        AlertaDengue(
            semanaEpidemiologica: 202403,
            casosNotificados: 40,
            casosEstimados: 45,
            nivelAlerta: 3),
      ];

      final resumo = ResumoDengue.calcular(alertas);

      expect(resumo.totalCasosAno, 75); // 10 + 25 + 40
    });

    test('conta corretamente semanas com nível de pico (>= 3)', () {
      final alertas = [
        AlertaDengue(
            semanaEpidemiologica: 202401,
            casosNotificados: 5,
            casosEstimados: 5,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202402,
            casosNotificados: 20,
            casosEstimados: 22,
            nivelAlerta: 3),
        AlertaDengue(
            semanaEpidemiologica: 202403,
            casosNotificados: 35,
            casosEstimados: 38,
            nivelAlerta: 4),
      ];

      final resumo = ResumoDengue.calcular(alertas);

      expect(resumo.semanasPicoNivel, 2); // semanas com nível 3 e 4
    });

    test('detecta tendência de subida quando média recente > 115% da anterior',
        () {
      // 6 semanas: primeiras 3 com poucos casos, últimas 3 com muitos
      final alertas = [
        // semanas anteriores (baixo)
        AlertaDengue(
            semanaEpidemiologica: 202401,
            casosNotificados: 10,
            casosEstimados: 10,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202402,
            casosNotificados: 10,
            casosEstimados: 10,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202403,
            casosNotificados: 10,
            casosEstimados: 10,
            nivelAlerta: 1),
        // semanas recentes (alto — média > 115% de 10)
        AlertaDengue(
            semanaEpidemiologica: 202404,
            casosNotificados: 50,
            casosEstimados: 55,
            nivelAlerta: 3),
        AlertaDengue(
            semanaEpidemiologica: 202405,
            casosNotificados: 60,
            casosEstimados: 65,
            nivelAlerta: 3),
        AlertaDengue(
            semanaEpidemiologica: 202406,
            casosNotificados: 70,
            casosEstimados: 75,
            nivelAlerta: 4),
      ];

      final resumo = ResumoDengue.calcular(alertas);

      expect(resumo.tendencia, TendenciaCasos.subindo);
    });

    test('detecta tendência de queda quando média recente < 85% da anterior',
        () {
      final alertas = [
        // semanas anteriores (alto)
        AlertaDengue(
            semanaEpidemiologica: 202401,
            casosNotificados: 80,
            casosEstimados: 85,
            nivelAlerta: 4),
        AlertaDengue(
            semanaEpidemiologica: 202402,
            casosNotificados: 90,
            casosEstimados: 95,
            nivelAlerta: 4),
        AlertaDengue(
            semanaEpidemiologica: 202403,
            casosNotificados: 70,
            casosEstimados: 75,
            nivelAlerta: 3),
        // semanas recentes (baixo — média < 85% de ~80)
        AlertaDengue(
            semanaEpidemiologica: 202404,
            casosNotificados: 10,
            casosEstimados: 12,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202405,
            casosNotificados: 8,
            casosEstimados: 9,
            nivelAlerta: 1),
        AlertaDengue(
            semanaEpidemiologica: 202406,
            casosNotificados: 12,
            casosEstimados: 13,
            nivelAlerta: 1),
      ];

      final resumo = ResumoDengue.calcular(alertas);

      expect(resumo.tendencia, TendenciaCasos.descendo);
    });

    test('retorna estável quando há menos de 6 semanas', () {
      final alertas = List.generate(
        4,
        (i) => AlertaDengue(
          semanaEpidemiologica: 202401 + i,
          casosNotificados: 20,
          casosEstimados: 22,
          nivelAlerta: 2,
        ),
      );

      final resumo = ResumoDengue.calcular(alertas);

      expect(resumo.tendencia, TendenciaCasos.estavel);
    });
  });
}
