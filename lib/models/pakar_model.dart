import 'dart:convert';

/// Satu rule gejala (R01–R08) beserta bobot CF pakar dan saran pengecekan.
class GejalaRule {
  final String kode;
  final String pernyataan;
  final double cfPakar;
  final String saran;

  const GejalaRule({
    required this.kode,
    required this.pernyataan,
    required this.cfPakar,
    required this.saran,
  });

  Map<String, dynamic> toMap() => {
        'kode': kode,
        'pernyataan': pernyataan,
        'cf_pakar': cfPakar,
        'saran': saran,
      };

  factory GejalaRule.fromMap(Map<String, dynamic> map) => GejalaRule(
        kode: map['kode'] as String,
        pernyataan: map['pernyataan'] as String,
        cfPakar: (map['cf_pakar'] as num).toDouble(),
        saran: map['saran'] as String,
      );
}

/// Pilihan tingkat keyakinan user (nilai 0.0 - 1.0).
class PilihanKeyakinan {
  final String label;
  final double nilai;

  const PilihanKeyakinan({required this.label, required this.nilai});

  Map<String, dynamic> toMap() => {'label': label, 'nilai': nilai};

  factory PilihanKeyakinan.fromMap(Map<String, dynamic> map) =>
      PilihanKeyakinan(
        label: map['label'] as String,
        nilai: (map['nilai'] as num).toDouble(),
      );
}

/// Gejala yang dipilih user beserta hasil CF per rule.
class GejalaTerpilih {
  final String kode;
  final String pernyataan;
  final String label;
  final double cfUser;
  final double cfRule;

  const GejalaTerpilih({
    required this.kode,
    required this.pernyataan,
    required this.label,
    required this.cfUser,
    required this.cfRule,
  });

  Map<String, dynamic> toMap() => {
        'kode': kode,
        'pernyataan': pernyataan,
        'label': label,
        'cf_user': cfUser,
        'cf_rule': cfRule,
      };

  factory GejalaTerpilih.fromMap(Map<String, dynamic> map) => GejalaTerpilih(
        kode: map['kode'] as String,
        pernyataan: map['pernyataan'] as String,
        label: map['label'] as String,
        cfUser: (map['cf_user'] as num).toDouble(),
        cfRule: (map['cf_rule'] as num).toDouble(),
      );
}

/// Hasil diagnosa. Output utama: [persentaseKesehatan] (0 - 100).
class HasilDiagnosa {
  final int? id;
  final double persentaseKesehatan;
  final double totalRisiko; // 0.0 - 1.0 (hasil kombinasi CF)
  final String status;
  final List<GejalaTerpilih> gejalaTerpilih;
  final List<String> saran;
  final DateTime tanggal;

  const HasilDiagnosa({
    this.id,
    required this.persentaseKesehatan,
    required this.totalRisiko,
    required this.status,
    required this.gejalaTerpilih,
    required this.saran,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'persentase': persentaseKesehatan,
        'total_risiko': totalRisiko,
        'status': status,
        'gejala_json': jsonEncode(gejalaTerpilih.map((g) => g.toMap()).toList()),
        'saran_json': jsonEncode(saran),
        'tanggal': tanggal.toIso8601String(),
      };

  factory HasilDiagnosa.fromMap(Map<String, dynamic> map) {
    final gejala = (jsonDecode(map['gejala_json'] as String) as List)
        .map((e) => GejalaTerpilih.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
    final saran = List<String>.from(jsonDecode(map['saran_json'] as String));
    return HasilDiagnosa(
      id: map['id'] as int?,
      persentaseKesehatan: (map['persentase'] as num).toDouble(),
      totalRisiko: (map['total_risiko'] as num).toDouble(),
      status: map['status'] as String,
      gejalaTerpilih: gejala,
      saran: saran,
      tanggal: DateTime.parse(map['tanggal'] as String),
    );
  }
}