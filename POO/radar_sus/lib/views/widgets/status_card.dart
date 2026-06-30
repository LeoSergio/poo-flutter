import 'package:flutter/material.dart';
import '../../models/alerta_dengue.dart';
import '../screens/main_shell.dart';

class StatusCard extends StatelessWidget {
  final ResumoDengue resumo;
  final String nomeMunicipio;
  const StatusCard({super.key, required this.resumo, required this.nomeMunicipio});

  static const _orientacoes = {
    1: 'Manter vigilância de rotina. Continuar ações preventivas e monitoramento semanal.',
    2: 'Intensificar fiscalização de focos. Acionar equipes de controle vetorial.',
    3: 'Ativar sala de situação municipal. Reforçar UBS e comunicar secretaria estadual.',
    4: 'EMERGÊNCIA — Acionar plano de contingência. Articular leitos e insumos com estado.',
  };

  @override
  Widget build(BuildContext context) {
    final nivel = resumo.ultimaSemana.nivelAlerta;
    final cor = AppColors.nivelCor(nivel);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: AppColors.iconBg,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C3D78),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_rounded, size: 13, color: cor),
                      const SizedBox(width: 5),
                      Text('Risco ${AppColors.nivelTexto(nivel)}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const Spacer(),
                Text(resumo.ultimaSemana.periodoFormatado,
                    style: TextStyle(color: AppColors.subTitle, fontSize: 10)),
              ],
            ),
          ),

          // Métricas em grid
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                _MetricaCell(
                  valor: '${resumo.ultimaSemana.casosNotificados}',
                  label: 'Casos notificados',
                  accent: false,
                ),
                Container(width: 0.5, height: 56, color: AppColors.border),
                _MetricaCell(
                  valor: '${resumo.ultimaSemana.casosEstimados}',
                  label: 'Estimativa',
                  accent: true,
                ),
                Container(width: 0.5, height: 56, color: AppColors.border),
                _MetricaCell(
                  valor: '${resumo.totalCasosAno}',
                  label: 'Total no ano',
                  accent: false,
                ),
              ],
            ),
          ),

          // Orientação de ação
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    size: 13, color: AppColors.iconBg),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    _orientacoes[nivel] ?? '',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF3A6A9A), height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricaCell extends StatelessWidget {
  final String valor;
  final String label;
  final bool accent;
  const _MetricaCell({required this.valor, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(valor,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: accent ? AppColors.iconBg : AppColors.textPrimary,
                )),
            const SizedBox(height: 3),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: AppColors.textSec, height: 1.3)),
          ],
        ),
      ),
    );
  }
}
