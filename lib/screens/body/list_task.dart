import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/widgets/checkbox/normal_checkbox.dart';
import '../../providers/task_provider.dart';
import '../widgets/edit_task.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(22),
          shrinkWrap: true,
          itemCount: viewModel.tasks.length,
          itemBuilder: (context, index) {
            final task = viewModel.tasks[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CHECKBOX
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: NormalCheckbox(
                      value: task.isCompleted,
                      onChanged: () {
                        viewModel.toggleTaskStatus(task.id);
                      },
                    ),
                  ),

                  // SỰ KIỆN CLICK VÀO TASK
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Chuyển sang màn hình EditTaskScreen và truyền task hiện tại sang
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditTaskScreen(task: task),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                color: task.isCompleted ? Colors.grey : Colors.black,
                              ),
                            ),

                            // Hiển thị Folder Tag
                            if (task.folder != null) ...[
                              const SizedBox(height: 8),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: task.folder!.backgroundColor?.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    task.folder!.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: task.folder!.backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // Hiển thị Subtasks
                            if (task.subTask.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Column(
                                children: List.generate(task.subTask.length, (subIndex) {
                                  final subTask = task.subTask[subIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        // Checkbox của subtask
                                        NormalCheckbox(
                                          value: subTask.isCompleted,
                                          onChanged: () {
                                            viewModel.toggleTaskStatus(subTask.id);
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            subTask.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade700,
                                              decoration: subTask.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: Colors.grey.shade300),
        );
      },
    );
  }
}