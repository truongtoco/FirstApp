import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';

class DayTimeline extends StatefulWidget {
  final List<Task> tasks;
  final DateTime selectedDate;

  const DayTimeline({
    super.key,
    required this.tasks,
    required this.selectedDate,
  });

  @override
  State<DayTimeline> createState() => _DayTimelineState();
}

class _DayTimelineState extends State<DayTimeline> {
  static const double hourHeight = 80;
  final ScrollController _controller = ScrollController();
  late Timer _timer;
  DateTime now = DateTime.now();

  bool get isToday => DateUtils.isSameDay(widget.selectedDate, DateTime.now());

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => now = DateTime.now()),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isToday) _scrollToNow();
    });
  }

  void _scrollToNow() {
    final pos = (now.hour + now.minute / 60) * hourHeight - 200;
    if (_controller.hasClients) {
      _controller.jumpTo(pos.clamp(0, _controller.position.maxScrollExtent));
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _controller,
        child: SizedBox(
          height: 24 * hourHeight,
          child: Stack(
            children: [
              /// GRID
              ...List.generate(24, (h) {
                return Positioned(
                  top: h * hourHeight,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: Text(
                          '${h.toString().padLeft(2, '0')}:00',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                );
              }),

              ...widget.tasks.map((task) {
                final start = task.scheduledDate!;
                final startHour = start.hour + start.minute / 60;
                final height = (task.durationMinutes / 60) * hourHeight;

                final color = task.folder?.backgroundColor ?? Colors.blue;

                return Positioned(
                  top: startHour * hourHeight + 8,
                  left: 56,
                  right: 16,
                  height: height,
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${task.durationMinutes ~/ 60}h',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
