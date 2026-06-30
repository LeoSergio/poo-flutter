import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../viewmodels/alertas_viewmodel.dart';
import 'inicio_screen.dart';
import 'tendencias_screen.dart';
import 'mapa_screen.dart';
import 'config_screen.dart';

// Paleta de cores do mockup — centralizada aqui para reutilização
class AppColors {
  static const navBg       = Color(0xFF0C2340);
  static const navActive   = Color(0xFF4A9FD4);
  static const navInactive = Color(0xFF3A6A9A);
  static const appBarBg    = Color(0xFF0C2340);
  static const chipBg      = Color(0xFF1A3A5C);
  static const chipBorder  = Color(0xFF2A5A8C);
  static const chipText    = Color(0xFFA8CCE8);
  static const subTitle    = Color(0xFF7FA8C9);
  static const iconBg      = Color(0xFF1A5FA8);
  static const cardBg      = Colors.white;
  static const pageBg      = Color(0xFFF4F6F9);
  static const border      = Color(0xFFD0DCE8);
  static const textPrimary = Color(0xFF0C2340);
  static const textSec     = Color(0xFF5A7A9A);

  // Cores de nível de alerta
  static const baixo    = Color(0xFF1D9E75);
  static const moderado = Color(0xFFBA7517);
  static const alto     = Color(0xFF993C1D);
  static const critico  = Color(0xFFA32D2D);

  static Color nivelCor(int nivel) => switch (nivel) {
        1 => baixo,
        2 => moderado,
        3 => alto,
        4 => critico,
        _ => textSec,
      };

  static String nivelTexto(int nivel) => switch (nivel) {
        1 => 'Baixo',
        2 => 'Moderado',
        3 => 'Alto',
        4 => 'Muito Alto',
        _ => '-',
      };
}

class MainShell extends HookWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = useMemoized(() => AlertasViewModel());
    final abaAtual = useState(0);
    final municipioAtual = useValueListenable(vm.municipioSelecionado);

    useEffect(() {
      vm.carregarAlertas();
      return vm.dispose;
    }, []);

    final telas = [
      InicioScreen(vm: vm),
      TendenciasScreen(vm: vm),
      MapaScreen(vm: vm),
      const ConfigScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: _RadarAppBar(
        municipioAtual: municipioAtual,
        municipios: AlertasViewModel.municipios,
        onMunicipioSelecionado: vm.alterarMunicipio,
      ),
      body: telas[abaAtual.value],
      bottomNavigationBar: _RadarBottomNav(
        abaAtual: abaAtual.value,
        onTap: (i) => abaAtual.value = i,
      ),
    );
  }
}

// AppBar azul escuro igual ao mockup
class _RadarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int municipioAtual;
  final Map<int, String> municipios;
  final void Function(int) onMunicipioSelecionado;

  const _RadarAppBar({
    required this.municipioAtual,
    required this.municipios,
    required this.onMunicipioSelecionado,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBg,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: AppColors.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.radar_rounded, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('RadarSUS',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              Text('Vigilância Epidemiológica',
                  style: TextStyle(color: AppColors.subTitle, fontSize: 10)),
            ],
          ),
        ],
      ),
      actions: [
        // Chip seletor de município
        GestureDetector(
          onTap: () => _abrirSeletor(context),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.chipBg,
              border: Border.all(color: AppColors.chipBorder),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on_rounded, size: 13, color: AppColors.navActive),
                const SizedBox(width: 5),
                Text(
                  '${municipios[municipioAtual] ?? ''} - RN',
                  style: const TextStyle(color: AppColors.chipText, fontSize: 11),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 13, color: AppColors.chipText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _abrirSeletor(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Selecionar município',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15,
                    color: AppColors.textPrimary)),
          ),
          ...municipios.entries.map((e) => ListTile(
                leading: const Icon(Icons.location_city_rounded, color: AppColors.iconBg),
                title: Text(e.value,
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
                subtitle: const Text('Rio Grande do Norte',
                    style: TextStyle(color: AppColors.textSec, fontSize: 11)),
                trailing: municipioAtual == e.key
                    ? const Icon(Icons.check_rounded, color: AppColors.iconBg)
                    : null,
                onTap: () {
                  onMunicipioSelecionado(e.key);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Bottom navigation bar azul escuro
class _RadarBottomNav extends StatelessWidget {
  final int abaAtual;
  final void Function(int) onTap;

  const _RadarBottomNav({required this.abaAtual, required this.onTap});

  static const _itens = [
    (icon: Icons.home_rounded, label: 'Início'),
    (icon: Icons.show_chart_rounded, label: 'Tendências'),
    (icon: Icons.map_rounded, label: 'Mapa'),
    (icon: Icons.settings_rounded, label: 'Config.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBg,
        border: Border(top: BorderSide(color: Color(0xFF1A3A5C))),
      ),
      child: Row(
        children: List.generate(_itens.length, (i) {
          final ativo = abaAtual == i;
          final item = _itens[i];
          return Expanded(
            child: InkWell(
              onTap: () => onTap(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon,
                        size: 22,
                        color: ativo ? AppColors.navActive : AppColors.navInactive),
                    const SizedBox(height: 3),
                    Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        color: ativo ? AppColors.navActive : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(item.label,
                        style: TextStyle(
                          fontSize: 9,
                          color: ativo ? AppColors.navActive : AppColors.navInactive,
                        )),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
