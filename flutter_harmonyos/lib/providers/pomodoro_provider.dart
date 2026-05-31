import 'dart:convert';
import 'package:flutter_harmonyos/models/pomodoro_record.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

class PomodoroProvider extends ChangeNotifier {
  List<PomodoroRecord> _records = [];

  List<PomodoroRecord> get records => _records;

  PomodoroProvider() {
    _loadFromHive();
  }

  void _loadFromHive() {
    final box = Hive.box('pomodoro_records');
    final data = box.get('data') as String?;
    if (data != null) {
      final list = jsonDecode(data) as List<dynamic>;
      _records = list
          .map((e) => PomodoroRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      _initMockData();
    }
  }

  void _saveToHive() {
    final box = Hive.box('pomodoro_records');
    final data = jsonEncode(_records.map((r) => r.toJson()).toList());
    box.put('data', data);
  }

  void _initMockData() {
    final now = DateTime.now();
    _records = [
      PomodoroRecord(
        id: 'pr1',
        date: now,
        durationMinutes: 25,
        todoId: '2',
        todoTitle: '写英语作文',
        completedAt: DateTime(now.year, now.month, now.day, 10, 0),
      ),
      PomodoroRecord(
        id: 'pr2',
        date: now,
        durationMinutes: 25,
        todoId: '2',
        todoTitle: '写英语作文',
        completedAt: DateTime(now.year, now.month, now.day, 14, 30),
      ),
      PomodoroRecord(
        id: 'pr3',
        date: now.subtract(const Duration(days: 1)),
        durationMinutes: 30,
        completedAt: DateTime(now.year, now.month, now.day - 1, 15, 0),
      ),
      PomodoroRecord(
        id: 'pr4',
        date: now.subtract(const Duration(days: 2)),
        durationMinutes: 25,
        todoId: '1',
        todoTitle: '复习高数第三章',
        completedAt: DateTime(now.year, now.month, now.day - 2, 9, 0),
      ),
      PomodoroRecord(
        id: 'pr5',
        date: now.subtract(const Duration(days: 2)),
        durationMinutes: 25,
        todoId: '1',
        todoTitle: '复习高数第三章',
        completedAt: DateTime(now.year, now.month, now.day - 2, 11, 0),
      ),
      PomodoroRecord(
        id: 'pr6',
        date: now.subtract(const Duration(days: 2)),
        durationMinutes: 25,
        completedAt: DateTime(now.year, now.month, now.day - 2, 15, 0),
      ),
    ];
  }

  void addRecord(PomodoroRecord record) {
    _records.add(record);
    _saveToHive();
    notifyListeners();
  }

  List<PomodoroRecord> getRecordsForDate(DateTime date) {
    return _records.where((r) {
      return r.date.year == date.year &&
          r.date.month == date.month &&
          r.date.day == date.day;
    }).toList();
  }

  int getTotalMinutesForDate(DateTime date) {
    return getRecordsForDate(date)
        .fold(0, (sum, r) => sum + r.durationMinutes);
  }

  int get totalRecords {
    return _records.length;
  }

  int get totalMinutes {
    return _records.fold(0, (sum, r) => sum + r.durationMinutes);
  }

  int get todayRecords {
    final now = DateTime.now();
    return getRecordsForDate(now).length;
  }

  int get todayMinutes {
    return getTotalMinutesForDate(DateTime.now());
  }

  int get completedTodosCount {
    final now = DateTime.now();
    return getRecordsForDate(now).where((r) => r.todoId != null).length;
  }

  int getTotalMinutesForTodo(String todoId) {
    return _records
        .where((r) => r.todoId == todoId)
        .fold(0, (sum, r) => sum + r.durationMinutes);
  }

  Map<String, int> getMinutesPerDay(int days) {
    final result = <String, int>{};
    final now = DateTime.now();
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final key = '${date.month}/${date.day}';
      result[key] = getTotalMinutesForDate(date);
    }
    return result;
  }
}
