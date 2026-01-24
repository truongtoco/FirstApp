import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:horizontal_week_calendar/horizontal_week_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/calendar_provider.dart';
import '../screens/body/list_timeline.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CalendarProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Calendar ',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: DateFormat('d MMM').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),

      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: HorizontalWeekCalendar(onDateChange: provider.selectDate),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const Expanded(child: TaskTimeline()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
