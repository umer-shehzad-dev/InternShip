import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/blood_sugar_reading.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'blood_sugar.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE readings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value_mg_dl REAL NOT NULL,
            recorded_at INTEGER NOT NULL,
            conditions TEXT NOT NULL DEFAULT '',
            notes TEXT NOT NULL DEFAULT '',
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertReading(BloodSugarReading reading) async {
    final db = await database;
    return db.insert('readings', reading.toMap()..remove('id'));
  }

  Future<void> updateReading(BloodSugarReading reading) async {
    final db = await database;
    await db.update(
      'readings',
      reading
          .copyWith(updatedAt: DateTime.now())
          .toMap()
        ..remove('id'),
      where: 'id = ?',
      whereArgs: [reading.id],
    );
  }

  Future<void> deleteReading(int id) async {
    final db = await database;
    await db.delete('readings', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<BloodSugarReading>> getAllReadings() async {
    final db = await database;
    final maps = await db.query(
      'readings',
      orderBy: 'recorded_at DESC',
    );
    return maps.map(BloodSugarReading.fromMap).toList();
  }

  Future<BloodSugarReading?> getReadingById(int id) async {
    final db = await database;
    final maps = await db.query(
      'readings',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BloodSugarReading.fromMap(maps.first);
  }

  Future<List<BloodSugarReading>> getReadingsSince(DateTime since) async {
    final db = await database;
    final maps = await db.query(
      'readings',
      where: 'recorded_at >= ?',
      whereArgs: [since.millisecondsSinceEpoch],
      orderBy: 'recorded_at ASC',
    );
    return maps.map(BloodSugarReading.fromMap).toList();
  }

  Future<ReadingStats> getStatsSince(
    DateTime since, {
    required double lowTarget,
    required double highTarget,
  }) async {
    final readings = await getReadingsSince(since);
    if (readings.isEmpty) {
      return const ReadingStats(
        average: 0,
        minimum: 0,
        maximum: 0,
        count: 0,
        inRangePercent: 0,
      );
    }

    final values = readings.map((r) => r.valueMgDl).toList();
    final inRangeCount = values
        .where((v) => v >= lowTarget && v <= highTarget)
        .length;

    return ReadingStats(
      average: values.reduce((a, b) => a + b) / values.length,
      minimum: values.reduce((a, b) => a < b ? a : b),
      maximum: values.reduce((a, b) => a > b ? a : b),
      count: values.length,
      inRangePercent: (inRangeCount / values.length) * 100,
    );
  }
}
