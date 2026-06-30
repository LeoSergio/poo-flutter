import 'package:flutter/material.dart';
import '../../models/alerta_dengue.dart';
import '../screens/main_shell.dart';

class AlertaCard extends StatelessWidget {
  final AlertaDengue alerta;
  const AlertaCard({super.key, required this.alerta});

  @override
  Widget build(BuildContext context) {
    final cor = AppColors.nivelCor(alerta.nivelAlerta);
    final texto = AppColors.nivelTexto(alerta.nivelAlerta);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          // Barra lateral colorida
          Container(width: 4, height: 54, color: cor),

          // Período e casos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(alerta.periodoFormatado,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(
                    'Notificados: ${alerta.casosNotificados} · Estimativa: ${alerta.casosEstimados}',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSec),
                  ),
                ],
              ),
            ),
          ),

          // Chip de nível
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cor.withOpacity(0.5)),
            ),
            child: Text(texto,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: cor)),
          ),
        ],
      ),
    );
  }
}
