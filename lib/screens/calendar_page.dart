import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../providers/task_provider.dart';
import 'widgets/day_timeline.dart';
import 'widgets/horizontal_day_picker.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarProvider>();
    final taskProvider = context.watch<TaskProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      calendar.setTasks(taskProvider.tasks);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar'), centerTitle: true),
      body: Column(
        children: [
          HorizontalDayPicker(
            selectedDate: calendar.selectedDate,
            onChanged: calendar.changeDate,
          ),
          DayTimeline(
            tasks: calendar.tasksOfSelectedDay,
            selectedDate: calendar.selectedDate,
          ),
        ],
      ),
    );
  }
}
