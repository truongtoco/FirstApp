import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/checkbox/normal_checkbox.dart';
import 'package:task_manager_app/screens/edittaskscreen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final task = provider.getTaskById(taskId);
        if (task == null) {
          return const Scaffold(
            body: Center(child: Text('Task not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Task Detail'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskScreen(taskId: task.id),
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  NormalCheckbox(
                    value: task.isCompleted,
                    onChanged: () async => await provider.toggleTask(task.id),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (task.folder != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.folder!.backgroundColor!.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(task.folder!.title.toUpperCase()),
                ),
              if (task.remindAt != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(DateFormat('dd MMM yyyy • h:mm a').format(task.remindAt!)),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              const Text('Subtasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...task.subTask.map((sub) {
                return Row(
                  children: [
                    NormalCheckbox(
                      value: sub.isCompleted,
                      onChanged: () async => await provider.toggleSubTask(task.id, sub.id),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        sub.title,
                        style: TextStyle(
                          decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
