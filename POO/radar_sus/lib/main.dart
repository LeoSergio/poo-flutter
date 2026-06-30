import 'package:flutter/material.dart';
import 'views/screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RadarSusApp());
}

class RadarSusApp extends StatelessWidget {
  const RadarSusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadarSUS',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const MainShell(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1A5FA8),
        surface: Color(0xFFF4F6F9),
        onSurface: Color(0xFF0C2340),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      fontFamily: 'Roboto',
    );
  }
}
