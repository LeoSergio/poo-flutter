// viewmodels/alertas_viewmodel.dart
// Receita 6 — Gerência de Estados #2: DataService com ValueNotifier
//
// Analogia do professor: esse é o "twitter" dos dados.
// A View assina (segue) o estado e se reconstrói automaticamente
// quando publicamos um novo valor via state.value = ...
//
// Responsabilidade: orquestrar a carga dos dados e expor o estado
// para a View. Não conhece widgets concretos.

import 'package:flutter/foundation.dart';
import '../models/alerta_dengue.dart';
import '../services/dengue_service.dart';

// ---------------------------------------------------------------------------
// Estados possíveis — sealed class (Dart 3+)
// Cada subclasse representa um estado bem definido do ciclo de vida dos dados
// (Receita 6: separar "o que" do "como")
// ---------------------------------------------------------------------------
sealed class AlertasState {}

class AlertasInicial extends AlertasState {}

class AlertasCarregando extends AlertasState {}

class AlertasCarregados extends AlertasState {
  final List<AlertaDengue> alertas;
  final ResumoDengue resumo;
  AlertasCarregados({required this.alertas, required this.resumo});
}

class AlertasErro extends AlertasState {
  final String mensagem;
  AlertasErro(this.mensagem);
}

// ---------------------------------------------------------------------------
// AlertasViewModel — equivalente ao DataService da Receita 6
//
// Expõe dois ValueNotifier (os "twitters"):
//   • state            — o estado completo dos dados de alertas
//   • municipioSelecionado — qual município está ativo no momento
//
// A View não mexe no estado diretamente; ela chama métodos públicos
// como alterarMunicipio() e carregarAlertas() — injeção de dependência.
// ---------------------------------------------------------------------------
class AlertasViewModel {
  // Mapa de municípios disponíveis — informação de domínio, não de UI
  static const Map<int, String> municipios = {
    2408102: 'Natal',
    2402006: 'Caicó',
    2411205: 'Santa Cruz',
  };

  // "Twitters" — Receita 6: ValueNotifier como estado global observável
  final state = ValueNotifier<AlertasState>(AlertasInicial());
  final municipioSelecionado = ValueNotifier<int>(2408102);

  // Serviço injetado internamente — poderia vir por parâmetro para testes
  final _service = DengueService();

  // Troca o município e dispara nova carga — callback que a View invoca
  // (Receita 6: itemSelectedCallback pattern)
  void alterarMunicipio(int codigoIBGE) {
    if (municipioSelecionado.value == codigoIBGE) return;
    municipioSelecionado.value = codigoIBGE;
    carregarAlertas();
  }

  // Método assíncrono — Receita 7: async/await
  // Publica no "twitter" (state.value) a cada mudança de fase
  Future<void> carregarAlertas() async {
    state.value = AlertasCarregando();
    try {
      final alertas = await _service.fetchAlertas(municipioSelecionado.value);
      // Ordena do mais recente para o mais antigo para exibição
      alertas.sort(
        (a, b) => b.semanaEpidemiologica.compareTo(a.semanaEpidemiologica),
      );
      final resumo = ResumoDengue.calcular(alertas);
      state.value = AlertasCarregados(alertas: alertas, resumo: resumo);
    } catch (e) {
      state.value = AlertasErro(e.toString());
    }
  }

  // Libera recursos — importante em HookWidget com useMemoized/useEffect
  void dispose() {
    state.dispose();
    municipioSelecionado.dispose();
    _service.dispose();
  }
}
