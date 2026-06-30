import 'package:flutter/material.dart';
import 'main_shell.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      children: [
        const _SectionLabel('Configurações'),
        const SizedBox(height: 8),
        _ConfigSection(titulo: 'Municípios', itens: [
          _ConfigItem(
            icone: Icons.location_on_rounded,
            iconeBg: const Color(0xFFE6F1FB),
            iconeColor: AppColors.iconBg,
            label: 'Município padrão',
            sub: 'Natal - RN',
            trailing: const _Chevron(),
          ),
          _ConfigItem(
            icone: Icons.add_rounded,
            iconeBg: const Color(0xFFE6F1FB),
            iconeColor: AppColors.iconBg,
            label: 'Adicionar município',
            sub: 'Monitorar outra cidade',
            trailing: const _Chevron(),
          ),
        ]),
        const SizedBox(height: 10),
        _ConfigSection(titulo: 'Notificações', itens: [
          _ConfigItem(
            icone: Icons.notifications_rounded,
            iconeBg: const Color(0xFFFAEEDA),
            iconeColor: AppColors.moderado,
            label: 'Alertas de nível',
            sub: 'Notificar ao subir de nível',
            trailing: const _Toggle(ativo: true),
          ),
          _ConfigItem(
            icone: Icons.schedule_rounded,
            iconeBg: const Color(0xFFFAEEDA),
            iconeColor: AppColors.moderado,
            label: 'Atualização semanal',
            sub: 'Toda segunda-feira',
            trailing: const _Toggle(ativo: false),
          ),
        ]),
        const SizedBox(height: 10),
        _ConfigSection(titulo: 'Dados e privacidade', itens: [
          _ConfigItem(
            icone: Icons.refresh_rounded,
            iconeBg: const Color(0xFFE1F5EE),
            iconeColor: AppColors.baixo,
            label: 'Fonte dos dados',
            sub: 'info.dengue.mat.br',
            trailing: const _Chevron(),
          ),
          _ConfigItem(
            icone: Icons.delete_outline_rounded,
            iconeBg: const Color(0xFFFCEBEB),
            iconeColor: AppColors.critico,
            label: 'Limpar cache local',
            sub: 'Apagar dados salvos',
            trailing: const _Chevron(),
          ),
        ]),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'RadarSUS v1.0.0 · dados: InfoDengue / Fiocruz',
            style: TextStyle(fontSize: 10, color: AppColors.textSec),
          ),
        ),
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

class _ConfigSection extends StatelessWidget {
  final String titulo;
  final List<_ConfigItem> itens;
  const _ConfigSection({required this.titulo, required this.itens});

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Text(titulo.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                    color: AppColors.textSec, letterSpacing: 0.8)),
          ),
          ...itens.map((item) => Column(children: [
                const Divider(height: 0.5, color: Color(0xFFF0F4F8)),
                item,
              ])),
        ],
      ),
    );
  }
}

class _ConfigItem extends StatelessWidget {
  final IconData icone;
  final Color iconeBg;
  final Color iconeColor;
  final String label;
  final String sub;
  final Widget trailing;

  const _ConfigItem({
    required this.icone,
    required this.iconeBg,
    required this.iconeColor,
    required this.label,
    required this.sub,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(color: iconeBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icone, size: 15, color: iconeColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textSec)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();
  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.border);
}

class _Toggle extends StatelessWidget {
  final bool ativo;
  const _Toggle({required this.ativo});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32, height: 18,
      decoration: BoxDecoration(
        color: ativo ? AppColors.iconBg : AppColors.border,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Align(
        alignment: ativo ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 14, height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
