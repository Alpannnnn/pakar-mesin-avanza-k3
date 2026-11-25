import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pakar_mesin_avanza_k3/data/knowledge_base_k3.dart';
import 'package:pakar_mesin_avanza_k3/models/pakar_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbName = 'pakar_mesin_avanza_k3.db';
  static const int _dbVersion = 1;
  static const String _kunciTema = 'tema';

  Database? _db;

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rules (
        kode TEXT PRIMARY KEY,
        pernyataan TEXT NOT NULL,
        cf_pakar REAL NOT NULL,
        saran TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE riwayat (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        persentase REAL NOT NULL,
        total_risiko REAL NOT NULL,
        status TEXT NOT NULL,
        gejala_json TEXT NOT NULL,
        saran_json TEXT NOT NULL,
        tanggal TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE pengaturan (
        kunci TEXT PRIMARY KEY,
        nilai TEXT NOT NULL
      )
    ''');

    // Seed 8 rules dari knowledge base + tema default.
    final batch = db.batch();
    for (final rule in kRulesK3) {
      batch.insert('rules', rule.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    batch.insert('pengaturan', {'kunci': _kunciTema, 'nilai': 'light'},
        conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit(noResult: true);
  }

  // ---------- Rules ----------
  Future<List<GejalaRule>> getRules() async {
    final db = await database;
    final rows = await db.query('rules', orderBy: 'kode ASC');
    return rows.map(GejalaRule.fromMap).toList();
  }

  // ---------- Riwayat ----------
  Future<int> simpanRiwayat(HasilDiagnosa hasil) async {
    final db = await database;
    return db.insert('riwayat', hasil.toMap());
  }

  Future<List<HasilDiagnosa>> getRiwayat() async {
    final db = await database;
    final rows = await db.query('riwayat', orderBy: 'tanggal DESC');
    return rows.map(HasilDiagnosa.fromMap).toList();
  }

  // ---------- Preferensi tema ----------
  /// Mengembalikan 'light' atau 'dark'.
  Future<String> getTema() async {
    final db = await database;
    final rows = await db.query(
      'pengaturan',
      where: 'kunci = ?',
      whereArgs: [_kunciTema],
      limit: 1,
    );
    if (rows.isEmpty) return 'light';
    return rows.first['nilai'] as String;
  }

  Future<void> simpanTema(String nilai) async {
    final db = await database;
    await db.insert(
      'pengaturan',
      {'kunci': _kunciTema, 'nilai': nilai},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}