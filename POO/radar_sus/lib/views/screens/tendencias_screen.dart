import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../viewmodels/alertas_viewmodel.dart';
import '../../models/alerta_dengue.dart';
import 'main_shell.dart';

class TendenciasScreen extends HookWidget {
  final AlertasViewModel vm;
  const TendenciasScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final state = useValueListenable(vm.state);

    return switch (state) {
      AlertasCarregando() => const Center(child: CircularProgressIndicator(color: AppColors.iconBg)),
      AlertasCarregados(:final alertas, :final resumo) => ListView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          children: [
            const _SectionLabel('Evolução semanal'),
            const SizedBox(height: 8),
            _GraficoCard(alertas: alertas, resumo: resumo),
            const SizedBox(height: 12),
            const _SectionLabel('Comparativo por semana'),
            const SizedBox(height: 8),
            _ComparativoCard(alertas: alertas.take(8).toList()),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _SectionLabel extends StatelessWidget {
  final String texto;
  const _SectionLabel(this.texto);
  @override
  Widget build(BuildContext context) => Text(
        texto.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.textSec, letterSpacing: 1.0),
      );
}

class _GraficoCard extends StatelessWidget {
  final List<AlertaDengue> alertas;
  final ResumoDengue resumo;
  const _GraficoCard({required this.alertas, required this.resumo});

  @override
  Widget build(BuildContext context) {
    final tendenciaTexto = switch (resumo.tendencia) {
      TendenciaCasos.subindo => 'Em alta',
      TendenciaCasos.descendo => 'Em queda',
      TendenciaCasos.estavel => 'Estável',
    };
    final tendenciaCor = switch (resumo.tendencia) {
      TendenciaCasos.subindo => AppColors.critico,
      TendenciaCasos.descendo => AppColors.baixo,
      TendenciaCasos.estavel => AppColors.iconBg,
    };
    final tendenciaIcon = switch (resumo.tendencia) {
      TendenciaCasos.subindo => Icons.trending_up_rounded,
      TendenciaCasos.descendo => Icons.trending_down_rounded,
      TendenciaCasos.estavel => Icons.trending_flat_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Casos notificados — ${DateTime.now().year}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          SizedBox(height: 110, child: _SparkLine(alertas: alertas)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _TrendStat(
                  valor: '${resumo.totalCasosAno}',
                  label: 'Total acumulado ${DateTime.now().year}',
                  pillText: tendenciaTexto,
                  pillCor: tendenciaCor,
                  pillIcon: tendenciaIcon,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TrendStat(
                  valor: '${resumo.semanasPicoNivel}',
                  label: 'Semanas em nível alto',
                  pillText: 'Estável',
                  pillCor: AppColors.iconBg,
                  pillIcon: Icons.remove_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparkLine extends StatelessWidget {
  final List<AlertaDengue> alertas;
  const _SparkLine({required this.alertas});

  @override
  Widget build(BuildContext context) {
    if (alertas.isEmpty) return const SizedBox();
    final ordenados = [...alertas]
      ..sort((a, b) => a.semanaEpidemiologica.compareTo(b.semanaEpidemiologica));
    final maxVal = ordenados.fold(1, (m, a) => a.casosNotificados > m ? a.casosNotificados : m);

    return CustomPaint(
      painter: _SparkLinePainter(alertas: ordenados, maxVal: maxVal.toDouble()),
    );
  }
}

class _SparkLinePainter extends CustomPainter {
  final List<AlertaDengue> alertas;
  final double maxVal;
  const _SparkLinePainter({required this.alertas, required this.maxVal});

  @override
  void paint(Canvas canvas, Size size) {
    if (alertas.isEmpty) return;
    final n = alertas.length;
    final w = size.width;
    final h = size.height * 0.85;

    // Grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE8EFF5)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 3; i++) {
      final y = h * (1 - i / 3);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // Pontos
    List<Offset> pts = List.generate(n, (i) {
      final x = n == 1 ? w / 2 : i * w / (n - 1);
      final y = h * (1 - alertas[i].casosNotificados / maxVal);
      return Offset(x, y);
    });

    // Área
    final path = Path()..moveTo(pts.first.dx, h);
    for (final p in pts) path.lineTo(p.dx, p.dy);
    path.lineTo(pts.last.dx, h);
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [const Color(0xFF1A5FA8).withOpacity(0.18), const Color(0xFF1A5FA8).withOpacity(0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Linha
    final linePaint = Paint()
      ..color = const Color(0xFF1A5FA8)
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final linePath = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) linePath.lineTo(pts[i].dx, pts[i].dy);
    canvas.drawPath(linePath, linePaint);

    // Pico destacado
    final maxIdx = alertas.indexWhere((a) => a.casosNotificados == maxVal.toInt());
    if (maxIdx >= 0) {
      canvas.drawCircle(pts[maxIdx], 3.5, Paint()..color = const Color(0xFF1A5FA8));
    }
    // Demais pontos
    final dotPaint = Paint()..color = const Color(0xFFC8D8E8);
    for (int i = 0; i < pts.length; i++) {
      if (i != maxIdx) canvas.drawCircle(pts[i], 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_SparkLinePainter old) => old.alertas != alertas;
}

class _TrendStat extends StatelessWidget {
  final String valor;
  final String label;
  final String pillText;
  final Color pillCor;
  final IconData pillIcon;
  const _TrendStat({required this.valor, required this.label,
      required this.pillText, required this.pillCor, required this.pillIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.pageBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valor,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 9, color: AppColors.textSec)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: pillCor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(pillIcon, size: 10, color: pillCor),
                const SizedBox(width: 4),
                Text(pillText,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: pillCor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparativoCard extends StatelessWidget {
  final List<AlertaDengue> alertas;
  const _ComparativoCard({required this.alertas});

  @override
  Widget build(BuildContext context) {
    if (alertas.isEmpty) return const SizedBox();
    final maxVal = alertas.fold(1, (m, a) => a.casosNotificados > m ? a.casosNotificados : m);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: alertas.map((a) {
          final cor = AppColors.nivelCor(a.nivelAlerta);
          final pct = maxVal == 0 ? 0.02 : (a.casosNotificados / maxVal).clamp(0.02, 1.0);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                Container(width: 8, height: 8,
                    decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  child: Text(a.periodoFormatado,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSec)),
                ),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8EFF5),
                        borderRadius: BorderRadius.circular(3)),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: pct,
                      child: Container(
                        decoration: BoxDecoration(
                            color: cor, borderRadius: BorderRadius.circular(3)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 20,
                  child: Text('${a.casosNotificados}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
