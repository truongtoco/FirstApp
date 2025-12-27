import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/checkbox/normal_checkbox.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(22),
          shrinkWrap: true,
          itemCount: value.tasks.length,
          itemBuilder: (context, index) {
            final task = value.tasks[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NormalCheckbox(
                    value: value.test,
                    onChanged: value.changeTaskStatus,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      if (task.folder != null) ...[
                        SizedBox(height: 8),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: task.folder?.backgroundColor?.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 2,
                            ),
                            child: Text(
                              task.folder?.title ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: task.folder?.backgroundColor,
                              ),
                            ),
                          ),
                        ),
                      ],

                      if (task.subTask.isNotEmpty) ...[
                        SizedBox(height: 8),
                        Column(
                          spacing: 8,
                          children: List.generate(task.subTask.length, (index) {
                            final subTask = task.subTask[index];
                            return Row(
                              children: [
                                NormalCheckbox(
                                  value: value.test,
                                  onChanged: value.changeTaskStatus,
                                ),
                                Text(
                                  subTask.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 8),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              Divider(color: Colors.grey.shade300),
        );
      },
    );
  }
}

