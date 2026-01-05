import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/providers/task_detail_provider.dart';
import 'package:task_manager_app/widgets/checkbox/normal_checkbox.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskDetailProvider(task),
      child: const _TaskDetailView(),
    );
  }
}

class _TaskDetailView extends StatelessWidget {
  const _TaskDetailView();

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<TaskDetailProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          TextButton(
            onPressed: () {
              final updatedTask = detail.buildUpdatedTask();

              context.read<TaskProvider>().updateTask(
                taskId: updatedTask.id,
                title: updatedTask.title,
                folder: updatedTask.folder,
                remindAt: updatedTask.remindAt,
                subTasks: updatedTask.subTask,
              );
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: detail.titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Task title',
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                NormalCheckbox(
                  value: detail.isCompleted,
                  onChanged: detail.toggleTask,
                ),
                const SizedBox(width: 8),
                const Text('Completed'),
              ],
            ),

            const Divider(height: 32),

            if (detail.subTasks.isNotEmpty) ...[
              const Text(
                'Subtasks',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...detail.subTasks.map((sub) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      NormalCheckbox(
                        value: sub.isCompleted,
                        onChanged: () => detail.toggleSubTask(sub.id),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          sub.title,
                          style: TextStyle(
                            decoration: sub.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
