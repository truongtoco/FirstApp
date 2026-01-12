import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';
import 'edit_task.dart';
// 1. Import ViewModel


class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    // 2. Dùng TaskViewModel
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, _) {
        // 3. Tìm Task từ list (Xử lý trường hợp không tìm thấy)
        final taskIndex = viewModel.tasks.indexWhere((t) => t.id == taskId);

        if (taskIndex == -1) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text("Task not found")),
          );
        }

        final task = viewModel.tasks[taskIndex];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task Detail'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Chuyển sang màn hình Edit
                  // (Logic Edit dùng TaskDetailProvider ở bước trước bạn nhét vào file này)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskScreen(task: task),
                    ),
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
                // Title
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // Folder Chip
                if (task.folder != null)
                  Chip(
                    label: Text(task.folder!.title),
                    backgroundColor: task.folder!.backgroundColor?.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: task.folder!.backgroundColor,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),

                const SizedBox(height: 16),

                // Date Time (Sửa remindAt -> scheduledDate)
                if (task.scheduledDate != null)
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM yyyy • h:mm a')
                            .format(task.scheduledDate!),
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Subtasks List
                if (task.subTask.isNotEmpty) ...[
                  const Text(
                    'Subtasks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
                            size: 20,
                            color: sub.isCompleted ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            sub.title,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                              color: sub.isCompleted ? Colors.grey : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}