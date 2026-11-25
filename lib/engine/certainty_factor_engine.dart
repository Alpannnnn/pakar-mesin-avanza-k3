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
}