import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;
  String get formattedDate => DateFormat('dd MMM yyyy').format(_selectedDate);

  late final Box<Task> _taskBox;
  Timer? _timer;

  CalendarProvider() {
    _taskBox = Hive.box<Task>('tasks');
    _startTodaySync();
  }

  void _startTodaySync() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();
      if (_isSameDay(_selectedDate, now)) {
        _selectedDate = now;
        notifyListeners();
      }
    });
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksOfSelectedDate {
    return _taskBox.values
        .where(
          (task) =>
              task.scheduledDate != null &&
              _isSameDay(task.scheduledDate!, _selectedDate),
        )
        .toList()
      ..sort((a, b) => a.scheduledDate!.compareTo(b.scheduledDate!));
  }

  Future<void> addTask({
    required String title,
    required DateTime scheduledDate,
    DateTime? remindAt,
  }) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      scheduledDate: scheduledDate,
      remindAt: remindAt,
    );

    await _taskBox.put(task.id, task);
    notifyListeners();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
