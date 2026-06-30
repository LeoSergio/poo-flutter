import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../viewmodels/alertas_viewmodel.dart';
import '../../models/alerta_dengue.dart';
import 'main_shell.dart';

class MapaScreen extends HookWidget {
  final AlertasViewModel vm;
  const MapaScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final state = useValueListenable(vm.state);
    final municipioAtual = useValueListenable(vm.municipioSelecionado);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        const _SectionLabel('Municípios monitorados'),
        const SizedBox(height: 8),
        _MapaRN(municipioAtual: municipioAtual),
        const SizedBox(height: 12),
        const _SectionLabel('Status por cidade'),
        const SizedBox(height: 8),
        _ListaCidades(state: state, municipioAtual: municipioAtual, onSelect: vm.alterarMunicipio),
      ],
    );
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

class _MapaRN extends StatelessWidget {
  final int municipioAtual;
  const _MapaRN({required this.municipioAtual});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: CustomPaint(
              size: const Size(double.infinity, 160),
              painter: _MapaPainter(municipioAtual: municipioAtual),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColors.cardBg,
            child: Row(
              children: [
                _LegendaItem(cor: AppColors.iconBg, label: 'Natal'),
                const SizedBox(width: 12),
                _LegendaItem(cor: AppColors.baixo, label: 'Caicó'),
                const SizedBox(width: 12),
                _LegendaItem(cor: AppColors.moderado, label: 'Santa Cruz'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapaPainter extends CustomPainter {
  final int municipioAtual;
  const _MapaPainter({required this.municipioAtual});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Fundo
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h),
        Paint()..color = const Color(0xFFD8E8F0));

    // Silhueta do RN (elipse simplificada)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.64, height: h * 0.76),
      Paint()..color = const Color(0xFFC0D8E8)..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.64, height: h * 0.76),
      Paint()..color = const Color(0xFFA8C8DC)..style = PaintingStyle.stroke..strokeWidth = 0.5,
    );

    // Municípios
    _drawCity(canvas, Offset(w * 0.38, h * 0.42), AppColors.iconBg, 'NAT', municipioAtual == 2408102);
    _drawCity(canvas, Offset(w * 0.64, h * 0.56), AppColors.baixo, 'CAI', municipioAtual == 2402006);
    _drawCity(canvas, Offset(w * 0.50, h * 0.66), AppColors.moderado, 'STC', municipioAtual == 2411205);

    // Label estado
    final tp = TextPainter(
      text: const TextSpan(
          text: 'Rio Grande do Norte',
          style: TextStyle(fontSize: 8, color: Color(0xFF8AA0B8))),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset((w - tp.width) / 2, h * 0.9));
  }

  void _drawCity(Canvas canvas, Offset center, Color cor, String label, bool selecionado) {
    final r = selecionado ? 10.0 : 7.0;
    if (selecionado) {
      canvas.drawCircle(center, r + 3, Paint()..color = cor.withOpacity(0.25));
    }
    canvas.drawCircle(center, r, Paint()..color = cor.withOpacity(0.9));
    final tp = TextPainter(
      text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 6, color: Colors.white, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_MapaPainter old) => old.municipioAtual != municipioAtual;
}

class _LegendaItem extends StatelessWidget {
  final Color cor;
  final String label;
  const _LegendaItem({required this.cor, required this.label});
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: cor, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSec)),
        ],
      );
}

class _ListaCidades extends StatelessWidget {
  final AlertasState state;
  final int municipioAtual;
  final void Function(int) onSelect;

  const _ListaCidades({required this.state, required this.municipioAtual, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    // Monta lista de cidades com status quando dados disponíveis
    final Map<int, (int nivel, int casos)> statusMap = {};
    if (state is AlertasCarregados) {
      final dados = state as AlertasCarregados;
      if (dados.alertas.isNotEmpty) {
        statusMap[municipioAtual] = (
          dados.resumo.ultimaSemana.nivelAlerta,
          dados.resumo.totalCasosAno,
        );
      }
    }

    return Column(
      children: AlertasViewModel.municipios.entries.map((e) {
        final status = statusMap[e.key];
        final nivel = status?.$1 ?? 1;
        final casos = status?.$2 ?? 0;
        final cor = AppColors.nivelCor(nivel);
        final ativo = municipioAtual == e.key;

        return GestureDetector(
          onTap: () => onSelect(e.key),
          child: Container(
            margin: const EdgeInsets.only(bottom: 7),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: ativo ? AppColors.iconBg : AppColors.border,
                  width: ativo ? 1.5 : 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                      color: cor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.location_city_rounded, size: 15, color: cor),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.value,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary)),
                      Text(
                        ativo && casos > 0
                            ? '$casos casos · semana atual'
                            : 'Rio Grande do Norte',
                        style: const TextStyle(fontSize: 10, color: AppColors.textSec),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cor.withOpacity(0.4)),
                  ),
                  child: Text(AppColors.nivelTexto(nivel),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: cor)),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
