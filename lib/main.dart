import 'package:flutter/material.dart';

import 'package:pakar_mesin_avanza_k3/data/database_helper.dart';
import 'package:pakar_mesin_avanza_k3/screens/diagnosa_screen.dart';
import 'package:pakar_mesin_avanza_k3/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SQLite (membuat tabel + seed 8 rules saat pertama kali)
  // lalu muat preferensi tema tersimpan.
  final tema = await DatabaseHelper.instance.getTema();
  final modeAwal = tema == 'dark' ? ThemeMode.dark : ThemeMode.light;

  runApp(PakarMesinApp(modeAwal: modeAwal));
}

class PakarMesinApp extends StatefulWidget {
  final ThemeMode modeAwal;

  const PakarMesinApp({super.key, required this.modeAwal});

  @override
  State<PakarMesinApp> createState() => _PakarMesinAppState();
}

class _PakarMesinAppState extends State<PakarMesinApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.modeAwal;
  }

  Future<void> _toggleTheme() async {
    final baru =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setState(() => _themeMode = baru); // langsung berubah di seluruh aplikasi
    await DatabaseHelper.instance
        .simpanTema(baru == ThemeMode.dark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakar Mesin Avanza K3',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: DiagnosaScreen(onToggleTheme: _toggleTheme),
    );
  }
}