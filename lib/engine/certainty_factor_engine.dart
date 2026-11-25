import 'package:pakar_mesin_avanza_k3/data/knowledge_base_k3.dart';
import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';

class CertaintyFactorEngine {
  CertaintyFactorEngine._();

  /// Membersihkan nilai CF: null / NaN / negatif -> 0.0, maksimum 1.0.
  static double bersihkan(double? nilai) {
    if (nilai == null || nilai.isNaN || nilai < 0) return 0.0;
    if (nilai > 1) return 1.0;
    return nilai;
  }

  /// CF per rule = CF_user * CF_pakar.
  static double hitungCfRule(double? cfUser, double cfPakar) {
    return bersihkan(cfUser) * bersihkan(cfPakar);
  }

  /// Kombinasi CF (nilai positif): CF_combine = CF1 + CF2 * (1 - CF1).
  static double gabungkan(List<double> daftarCf) {
    double hasil = 0.0;
    for (final cf in daftarCf) {
      final nilai = bersihkan(cf);
      if (nilai <= 0) continue;
      hasil = hasil + nilai * (1 - hasil);
    }
    return hasil.clamp(0.0, 1.0).toDouble();
  }

  /// Menghitung persentase kesehatan mobil (0 - 100) dari 8 rules.
  /// [jawaban] : kode rule -> CF user (0.0 - 1.0). Rule tanpa jawaban dianggap 0.
  static HasilDiagnosa hitung({
    required List<GejalaRule> rules,
    required Map<String, double> jawaban,
  }) {
    final terpilih = <GejalaTerpilih>[];
    final cfList = <double>[];
    final saranBerbobot = <MapEntry<double, String>>[];

    for (final rule in rules) {
      final cfUser = bersihkan(jawaban[rule.kode]);
      final cfRule = hitungCfRule(cfUser, rule.cfPakar);
      if (cfRule <= 0) continue;

      cfList.add(cfRule);
      terpilih.add(GejalaTerpilih(
        kode: rule.kode,
        pernyataan: rule.pernyataan,
        label: _labelUntuk(cfUser),
        cfUser: cfUser,
        cfRule: cfRule,
      ));
      saranBerbobot.add(MapEntry(cfRule, rule.saran));
    }

    final totalRisiko = gabungkan(cfList);
    final persen = ((1 - totalRisiko) * 100).clamp(0.0, 100.0).toDouble();

    saranBerbobot.sort((a, b) => b.key.compareTo(a.key));
    final saran = saranBerbobot.take(3).map((e) => e.value).toList();
    if (saran.isEmpty) {
      saran.add('Kondisi mesin baik. Lanjutkan servis berkala sesuai jadwal.');
    }

    return HasilDiagnosa(
      persentaseKesehatan: persen,
      totalRisiko: totalRisiko,
      status: _statusDari(persen),
      gejalaTerpilih: terpilih,
      saran: saran,
      tanggal: DateTime.now(),
    );
  }

  static String _statusDari(double persen) {
    if (persen >= 80) return 'Mesin dalam kondisi sehat';
    if (persen >= 60) return 'Mesin cukup sehat, perlu diperhatikan';
    if (persen >= 40) return 'Mesin kurang sehat, segera dicek';
    return 'Mesin butuh perawatan segera';
  }

  static String _labelUntuk(double nilai) {
    var terdekat = kPilihanKeyakinan.first;
    for (final p in kPilihanKeyakinan) {
      if ((p.nilai - nilai).abs() < (terdekat.nilai - nilai).abs()) {
        terdekat = p;
      }
    }
    return terdekat.label;
  }
}