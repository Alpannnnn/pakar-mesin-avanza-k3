import 'package:flutter/material.dart';

import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';

class GejalaCard extends StatelessWidget {
  final GejalaRule rule;
  final List<PilihanKeyakinan> pilihan;
  final double nilaiTerpilih;
  final ValueChanged<double> onChanged;

  const GejalaCard({
    super.key,
    required this.rule,
    required this.pilihan,
    required this.nilaiTerpilih,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rule.kode,
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(rule.pernyataan, style: theme.textTheme.titleMedium),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pilihan.map((p) {
                final aktif = (p.nilai - nilaiTerpilih).abs() < 0.001;
                return ChoiceChip(
                  label: Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 13,
                      color: aktif ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                  selected: aktif,
                  showCheckmark: false,
                  selectedColor: cs.primary,
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color: aktif ? cs.primary : cs.outline,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (_) => onChanged(p.nilai),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}