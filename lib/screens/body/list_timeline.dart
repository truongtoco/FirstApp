import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/calendar_provider.dart';
import 'package:task_manager_app/screens/widgets/item.dart';

class TaskTimeline extends StatelessWidget {
  const TaskTimeline({super.key});

  static const double hourHeight = 80;

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<CalendarProvider>().tasksOfSelectedDate;

    return SingleChildScrollView(
      child: SizedBox(
        height: 24 * hourHeight,
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: Column(
                children: List.generate(24, (hour) {
                  return SizedBox(
                    height: hourHeight,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                }),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: List.generate(24, (_) {
                      return SizedBox(
                        height: hourHeight,
                        child: const Divider(height: 1),
                      );
                    }),
                  ),

                  ...tasks.map((task) {
                    final start = task.scheduledDate!;
                    final top =
                        (start.hour * 60 + start.minute) / 60 * hourHeight;

                    final height = task.durationMinutes / 60 * hourHeight;

                    return Positioned(
                      top: top,
                      left: 8,
                      right: 8,
                      height: height,
                      child: Item(task: task),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
