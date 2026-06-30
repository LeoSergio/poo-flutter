import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../viewmodels/alertas_viewmodel.dart';
import '../../models/alerta_dengue.dart';
import '../widgets/status_card.dart';
import '../widgets/alerta_card.dart';
import 'main_shell.dart';

class InicioScreen extends HookWidget {
  final AlertasViewModel vm;
  const InicioScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final state = useValueListenable(vm.state);
    final municipio = useValueListenable(vm.municipioSelecionado);

    return switch (state) {
      AlertasInicial() => const SizedBox.shrink(),
      AlertasCarregando() => const Center(child: CircularProgressIndicator(color: AppColors.iconBg)),
      AlertasCarregados(:final alertas, :final resumo) => RefreshIndicator(
          onRefresh: vm.carregarAlertas,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
            children: [
              const _SectionLabel('Situação atual'),
              const SizedBox(height: 8),
              StatusCard(
                resumo: resumo,
                nomeMunicipio: AlertasViewModel.municipios[municipio]!,
              ),
              const SizedBox(height: 14),
              const _SectionLabel('Histórico semanal'),
              const SizedBox(height: 8),
              ...alertas.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: AlertaCard(alerta: a),
                  )),
            ],
          ),
        ),
      AlertasErro(:final mensagem) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textSec),
              const SizedBox(height: 12),
              Text(mensagem,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSec, fontSize: 13)),
              const SizedBox(height: 16),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.iconBg),
                onPressed: vm.carregarAlertas,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
    };
  }
}

class _SectionLabel extends StatelessWidget {
  final String texto;
  const _SectionLabel(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSec,
        letterSpacing: 1.0,
      ),
    );
  }
}
