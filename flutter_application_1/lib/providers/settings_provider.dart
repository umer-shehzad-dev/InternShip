import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/glucose_ranges.dart';
import '../models/blood_sugar_reading.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  static const _unitKey = 'unit';
  static const _lowTargetKey = 'low_target';
  static const _highTargetKey = 'high_target';
  static const _customNotesKey = 'custom_notes';

  GlucoseUnit _unit = GlucoseUnit.mgDl;
  double _lowTarget = GlucoseRanges.defaultLowTargetMgDl;
  double _highTarget = GlucoseRanges.defaultHighTargetMgDl;
  List<String> _customNotes = [];
  bool _isLoaded = false;

  GlucoseUnit get unit => _unit;
  double get lowTarget => _lowTarget;
  double get highTarget => _highTarget;
  List<String> get customNotes => List.unmodifiable(_customNotes);
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _unit = GlucoseUnit.values[prefs.getInt(_unitKey) ?? 0];
    _lowTarget =
        prefs.getDouble(_lowTargetKey) ?? GlucoseRanges.defaultLowTargetMgDl;
    _highTarget =
        prefs.getDouble(_highTargetKey) ?? GlucoseRanges.defaultHighTargetMgDl;
    _customNotes = prefs.getStringList(_customNotesKey) ?? [];
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setUnit(GlucoseUnit unit) async {
    _unit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_unitKey, unit.index);
    notifyListeners();
  }

  Future<void> setLowTarget(double value) async {
    _lowTarget = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lowTargetKey, value);
    notifyListeners();
  }

  Future<void> setHighTarget(double value) async {
    _highTarget = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_highTargetKey, value);
    notifyListeners();
  }

  Future<void> addCustomNote(String note) async {
    final trimmed = note.trim();
    if (trimmed.isEmpty || _customNotes.contains(trimmed)) return;
    _customNotes = [..._customNotes, trimmed];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_customNotesKey, _customNotes);
    notifyListeners();
  }
}

class ReadingsProvider extends ChangeNotifier {
  final DatabaseService _database = DatabaseService.instance;

  List<BloodSugarReading> _readings = [];
  bool _isLoading = false;

  List<BloodSugarReading> get readings => List.unmodifiable(_readings);
  bool get isLoading => _isLoading;

  BloodSugarReading? get latestReading =>
      _readings.isEmpty ? null : _readings.first;

  Future<void> loadReadings() async {
    _isLoading = true;
    notifyListeners();
    _readings = await _database.getAllReadings();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReading(BloodSugarReading reading) async {
    final id = await _database.insertReading(reading);
    _readings.insert(0, reading.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateReading(BloodSugarReading reading) async {
    await _database.updateReading(reading);
    final index = _readings.indexWhere((r) => r.id == reading.id);
    if (index != -1) {
      _readings[index] = reading;
      _readings.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      notifyListeners();
    }
  }

  Future<void> deleteReading(int id) async {
    await _database.deleteReading(id);
    _readings.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  List<BloodSugarReading> getRecentReadings(int count) {
    return _readings.take(count).toList();
  }

  List<BloodSugarReading> getReadingsForPeriod(int days) {
    final since = DateTime.now().subtract(Duration(days: days));
    return _readings
        .where((reading) => reading.recordedAt.isAfter(since))
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  Future<ReadingStats> getStatsForPeriod(
    int days, {
    required double lowTarget,
    required double highTarget,
  }) async {
    final since = DateTime.now().subtract(Duration(days: days));
    return _database.getStatsSince(
      since,
      lowTarget: lowTarget,
      highTarget: highTarget,
    );
  }

  Future<ReadingStats> getTodayStats({
    required double lowTarget,
    required double highTarget,
  }) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _database.getStatsSince(
      startOfDay,
      lowTarget: lowTarget,
      highTarget: highTarget,
    );
  }
}
