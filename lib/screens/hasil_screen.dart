import 'package:flutter/material.dart';

import 'package:pakar_mesin_avanza_k3/data/database_helper.dart';
import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';

class HasilScreen extends StatefulWidget {
  final HasilDiagnosa hasil;

  const HasilScreen({super.key, required this.hasil});

  @override
  State<HasilScreen> createState() => _HasilScreenState();
}

class _HasilScreenState extends State<HasilScreen> {
  bool _tersimpan = false;

  @override
  void initState() {
    super.initState();
    _simpan();
  }

  Future<void> _simpan() async {
    try {
      await DatabaseHelper.instance.simpanRiwayat(widget.hasil);
      if (mounted) setState(() => _tersimpan = true);
    } catch (_) {
      // Gagal menyimpan tidak boleh mengganggu tampilan hasil.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasil = widget.hasil;
    final persen = hasil.persentaseKesehatan;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Diagnosa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Output utama: persentase kesehatan mobil
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kesehatan Mobil', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    '${persen.toStringAsFixed(0)}%',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: persen / 100,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(hasil.status, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _judul(context, 'Gejala yang dipilih'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: hasil.gejalaTerpilih.isEmpty
                  ? Text('Tidak ada gejala yang dipilih.',
                      style: theme.textTheme.bodyMedium)
                  : Column(
                      children: [
                        for (var i = 0; i < hasil.gejalaTerpilih.length; i++) ...[
                          if (i > 0) const Divider(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  hasil.gejalaTerpilih[i].pernyataan,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                hasil.gejalaTerpilih[i].label,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),

          _judul(context, 'Saran pengecekan'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final s in hasil.saran)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(Icons.check_circle_outline,
                                size: 18, color: cs.primary),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(s, style: theme.textTheme.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (_tersimpan)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Hasil tersimpan di riwayat.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 4),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Diagnosa Ulang'),
          ),
        ],
      ),
    );
  }

  Widget _judul(BuildContext context, String teks) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(teks, style: Theme.of(context).textTheme.labelLarge),
      );
}