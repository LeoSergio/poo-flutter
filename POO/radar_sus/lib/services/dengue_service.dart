// services/dengue_service.dart
// Receitas 7 e 8 — Programação Assíncrona
// Responsabilidade única: comunicação com a API externa.
// Não conhece Flutter nem widgets — só Dart puro e HTTP.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/alerta_dengue.dart';

class DengueService {
  static const String _baseUrl = 'https://info.dengue.mat.br/api/alertcity';

  // Injeção de dependência do client HTTP — Receita 6
  // Permite substituir por mock nos testes sem alterar a classe
  final http.Client _client;

  DengueService({http.Client? client}) : _client = client ?? http.Client();

  // Método assíncrono — Receita 7: Future e async/await
  // Lança exceção em vez de retornar null para comunicar falhas claramente
  Future<List<AlertaDengue>> fetchAlertas(int geocode) async {
    final anoAtual = DateTime.now().year.toString();

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'geocode': geocode.toString(),
      'disease': 'dengue',
      'format': 'json',
      'ew_start': '1',
      'ew_end': '53',
      'ey_start': anoAtual,
      'ey_end': anoAtual,
    });

    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Erro na API: ${response.statusCode}');
      }

      // Receita 4: parsing do JSON usando o factory fromJson do modelo
      final List<dynamic> body = jsonDecode(response.body);
      return body
          .whereType<Map<String, dynamic>>()
          .map(AlertaDengue.fromJson)
          .toList();
    } catch (e) {
      throw Exception('Falha ao buscar alertas de dengue: $e');
    }
  }

  // Libera o client HTTP ao final do uso
  void dispose() => _client.close();
}
