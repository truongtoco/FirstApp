import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/task_detail_screen.dart';
import 'package:task_manager_app/widgets/checkbox/normal_checkbox.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final tasks = provider.tasks;

        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (tasks.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text("No tasks")),
          );
        }

        return SlidableAutoCloseBehavior(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            itemCount: tasks.length,
            separatorBuilder: (_, __) =>
                Divider(height: 24, color: Colors.grey.shade300),
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Slidable(
                key: ValueKey(task.id),
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) async {
                        await provider.deleteTask(task.id);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          NormalCheckbox(
                            value: task.isCompleted,
                            onChanged: () async {
                              await provider.toggleTask(task.id);
                            },
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskDetailScreen(taskId: task.id),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      if (task.folder != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: task.folder!.backgroundColor!
                                                .withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            task.folder!.title.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  task.folder!.backgroundColor,
                                            ),
                                          ),
                                        ),
                                      if (task.remindAt != null) ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat(
                                            'h:mm a',
                                          ).format(task.remindAt!),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (task.subTasks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: Column(
                            children: task.subTasks.map((sub) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    NormalCheckbox(
                                      value: sub.isCompleted,
                                      onChanged: () async {
                                        await provider.toggleSubTask(
                                          task.id,
                                          sub.id,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        sub.title,
                                        style: TextStyle(
                                          decoration: sub.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
