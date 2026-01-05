import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/screens/edittaskscreen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            if (task.folder != null)
              Chip(
                label: Text(task.folder!.title),
                backgroundColor: task.folder!.backgroundColor!.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: task.folder!.backgroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

            const SizedBox(height: 16),

            if (task.remindAt != null)
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('dd MMM yyyy • h:mm a').format(task.remindAt!),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            if (task.subTask.isNotEmpty) ...[
              const Text(
                'Subtasks',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...task.subTask.map(
                (sub) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        sub.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(sub.title),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
