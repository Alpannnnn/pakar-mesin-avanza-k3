import 'package:flutter/material.dart';

import 'package:pakar_mesin_avanza_k3/data/database_helper.dart';
import 'package:pakar_mesin_avanza_k3/data/knowledge_base_k3.dart';
import 'package:pakar_mesin_avanza_k3/engine/certainty_factor_engine.dart';
import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';
import 'package:pakar_mesin_avanza_k3/screens/hasil_screen.dart';
import 'package:pakar_mesin_avanza_k3/widgets/gejala_card.dart';

class DiagnosaScreen extends StatefulWidget {
  /// Dipanggil saat tombol pindah tema ditekan.
  final VoidCallback onToggleTheme;

  const DiagnosaScreen({super.key, required this.onToggleTheme});

  @override
  State<DiagnosaScreen> createState() => _DiagnosaScreenState();
}

class _DiagnosaScreenState extends State<DiagnosaScreen> {
  late final Future<List<GejalaRule>> _futureRules;
  final Map<String, double> _jawaban = {};

  @override
  void initState() {
    super.initState();
    _futureRules = DatabaseHelper.instance.getRules();
  }

  Future<void> _hitung(List<GejalaRule> rules) async {
    final hasil = CertaintyFactorEngine.hitung(
      rules: rules,
      jawaban: _jawaban,
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute(builder: (_) => HasilScreen(hasil: hasil)),
    );
    if (!mounted) return;
    setState(_jawaban.clear); // reset setelah "Diagnosa Ulang"
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pakar Mesin Avanza K3'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Mode terang' : 'Mode gelap',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: FutureBuilder<List<GejalaRule>>(
        future: _futureRules,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Gagal memuat data gejala.'));
          }
          final rules = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Cek kesehatan mesin',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih seberapa yakin Anda merasakan tiap kondisi berikut.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              for (final rule in rules) ...[
                GejalaCard(
                  rule: rule,
                  pilihan: kPilihanKeyakinan,
                  nilaiTerpilih: _jawaban[rule.kode] ?? 0.0,
                  onChanged: (nilai) =>
                      setState(() => _jawaban[rule.kode] = nilai),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _hitung(rules),
                child: const Text('Hitung Kesehatan Mobil'),
              ),
            ],
          );
        },
      ),
    );
  }
}