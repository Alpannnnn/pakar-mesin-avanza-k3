import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';

/// Opsi tingkat keyakinan user (CF user: 0.0 - 1.0).
const List<PilihanKeyakinan> kPilihanKeyakinan = [
  PilihanKeyakinan(label: 'Tidak', nilai: 0.0),
  PilihanKeyakinan(label: 'Mungkin', nilai: 0.4),
  PilihanKeyakinan(label: 'Cukup yakin', nilai: 0.6),
  PilihanKeyakinan(label: 'Yakin', nilai: 0.8),
  PilihanKeyakinan(label: 'Sangat yakin', nilai: 1.0),
];

/// Data awal (seed) 8 rules gejala Avanza seri K3.
const List<GejalaRule> kRulesK3 = [
  GejalaRule(
    kode: 'R01',
    pernyataan: 'Mesin sulit dihidupkan saat pagi hari.',
    cfPakar: 0.5,
    saran: 'Periksa kondisi aki dan busi di bengkel.',
  ),
  GejalaRule(
    kode: 'R02',
    pernyataan: 'Mesin bergetar kasar saat mobil diam.',
    cfPakar: 0.4,
    saran: 'Cek dudukan mesin dan kebersihan sistem bahan bakar.',
  ),
  GejalaRule(
    kode: 'R03',
    pernyataan: 'Tenaga mobil terasa berat saat menanjak.',
    cfPakar: 0.5,
    saran: 'Bersihkan saringan udara dan periksa kondisi busi.',
  ),
  GejalaRule(
    kode: 'R04',
    pernyataan: 'Keluar asap putih tebal dari knalpot.',
    cfPakar: 0.7,
    saran: 'Segera periksa kebocoran pada bagian dalam mesin.',
  ),
  GejalaRule(
    kode: 'R05',
    pernyataan: 'Bensin terasa lebih boros dari biasanya.',
    cfPakar: 0.3,
    saran: 'Lakukan servis berkala dan periksa tekanan angin ban.',
  ),
  GejalaRule(
    kode: 'R06',
    pernyataan: 'Suhu mesin cepat naik saat macet.',
    cfPakar: 0.7,
    saran: 'Periksa air radiator, kipas pendingin, dan kebocoran selang.',
  ),
  GejalaRule(
    kode: 'R07',
    pernyataan: 'Terdengar bunyi kasar dari dalam mesin.',
    cfPakar: 0.8,
    saran: 'Hentikan pemakaian lama dan bawa ke bengkel resmi.',
  ),
  GejalaRule(
    kode: 'R08',
    pernyataan: 'Oli mesin cepat berkurang.',
    cfPakar: 0.6,
    saran: 'Cek kebocoran oli dan ganti oli sesuai jadwal.',
  ),
];