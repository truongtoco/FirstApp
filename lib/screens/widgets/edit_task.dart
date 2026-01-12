import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/providers/edit_task_provider.dart';
import '../../providers/task_provider.dart';

class EditTaskScreen extends StatelessWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditTaskProvider(task),
      child: Consumer<EditTaskProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Task'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    final updatedTask = provider.buildUpdatedTask();
                    if (updatedTask != null) {
                      // Lưu xuống DB thông qua ViewModel chính
                      context.read<TaskViewModel>().updateTask(updatedTask);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // --- TASK TITLE ---
                TextField(
                  controller: provider.titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // --- FOLDER SELECTOR ---
                Consumer<TaskViewModel>(
                    builder: (context, globalVM, child) {
                      return DropdownButtonFormField<String>(
                        value: provider.selectedFolder?.id,
                        items: globalVM.folders.map((f) => DropdownMenuItem(
                          value: f.id,
                          child: Text(f.title),
                        )).toList(),
                        onChanged: (folderId) {
                          if (folderId != null) {
                            final folder = globalVM.getFolderById(folderId);
                            provider.setFolder(folder);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Folder',
                          border: OutlineInputBorder(),
                        ),
                      );
                    }
                ),

                const SizedBox(height: 20),

                // --- DATE PICK ---
                ListTile(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: provider.scheduledDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null && context.mounted) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(provider.scheduledDate ?? DateTime.now()),
                      );
                      if (time != null) {
                        provider.setDateTime(DateTime(
                            date.year, date.month, date.day, time.hour, time.minute
                        ));
                      }
                    }
                  },
                  leading: const Icon(Icons.access_time),
                  title: const Text('Scheduled Date'),
                  subtitle: Text(
                    provider.scheduledDate == null
                        ? 'Not set'
                        : DateFormat('dd MMM yyyy • h:mm a').format(provider.scheduledDate!),
                  ),
                  trailing: provider.scheduledDate != null
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: provider.clearDateTime,
                  )
                      : null,
                ),

                const Divider(height: 32),

                // --- SUBTASKS LIST ---
                const Text(
                  'Subtasks',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Dùng ... để trải list ra child của ListView
                ...provider.subTasks.map((sub) {
                  return ListTile(
                    key: ValueKey(sub.id),
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      value: sub.isCompleted,
                      onChanged: null,
                      side: BorderSide(color: Colors.grey.shade400),
                    ),

                    // Sử dụng TEXTFORMFIELD để chỉnh sửa SUBTASK
                    title: TextFormField(
                      initialValue: sub.title,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: "Enter subtask...",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (val) {
                        provider.updateSubTaskTitle(sub, val);
                      },
                    ),

                    // Nút xóa subtask
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () => provider.removeSubTask(sub),
                    ),
                  );
                }),

                // --- ADD SUBTASK BUTTON ---
                TextButton.icon(
                  onPressed: provider.addDummySubTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add subtask'),
                  style: TextButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}