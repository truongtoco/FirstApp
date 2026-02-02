import 'package:flutter/material.dart';
import '../models/task.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  List<Task> _tasks = [];

  DateTime get selectedDate => _selectedDate;

  void setTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void changeDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksOfSelectedDay {
    return _tasks.where((t) {
      if (t.scheduledDate == null) return false;
      return DateUtils.isSameDay(t.scheduledDate, _selectedDate);
    }).toList();
  }
}
