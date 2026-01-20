import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/providers/new_task_provider.dart';

import '../../providers/task_provider.dart'; // Import Provider riêng

class AddNewTask extends StatelessWidget {
  const AddNewTask({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Khởi tạo Provider riêng cho màn hình này
    return ChangeNotifierProvider(
      create: (_) => NewTaskProvider(),
      child: Consumer<NewTaskProvider>(
        builder: (context, formProvider, child) {
          // Lấy list folder từ Global ViewModel để hiển thị
          final folders = context.select((TaskViewModel vm) => vm.folders);
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

          return Container(
            padding: EdgeInsets.only(
              top: 20, left: 24, right: 24,
              bottom: keyboardHeight + 20,
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 28),
                  ),
                ),

                // Title Input
                TextField(
                  controller: formProvider.titleController,
                  autofocus: true,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  decoration: const InputDecoration(
                    hintText: "Write a new task...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),

                // Subtasks Section (List động)
                if (formProvider.subtaskControllers.isNotEmpty)
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: formProvider.subtaskControllers.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const Icon(Icons.subdirectory_arrow_right, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: formProvider.subtaskControllers[index],
                                decoration: const InputDecoration(hintText: "Enter subtask..."),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => formProvider.removeSubtaskField(index),
                            )
                          ],
                        );
                      },
                    ),
                  ),

                // Button Add Subtask
                TextButton.icon(
                  onPressed: formProvider.addSubtaskField,
                  icon: const Icon(Icons.add),
                  label: const Text("Add Subtask"),
                ),

                const SizedBox(height: 20),

                // Folder Selection Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: folders.map((folder) {
                    final isSelected = formProvider.selectedFolder?.id == folder.id;
                    return ChoiceChip(
                      label: Text(folder.title),
                      selected: isSelected,
                      selectedColor: folder.backgroundColor ?? Colors.blue,
                      onSelected: (_) => formProvider.selectFolder(folder),
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    );
                  }).toList(),
                ),

                const Spacer(),

                // Bottom Action Bar
                Row(
                  children: [
                    // Time Picker
                    IconButton(
                      icon: Icon(
                        Icons.access_time_filled,
                        color: formProvider.selectedDateTime != null ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () async {
                        final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                        );
                        if (time != null) {
                          final now = DateTime.now();
                          formProvider.selectDateTime(
                              DateTime(now.year, now.month, now.day, time.hour, time.minute)
                          );
                        }
                      },
                    ),
                    if (formProvider.selectedDateTime != null)
                      Text(DateFormat.Hm().format(formProvider.selectedDateTime!)),

                    const SizedBox(width: 16),

                    // SAVE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        // Nút chỉ enable khi formProvider.canSave == true
                        onPressed: formProvider.canSave
                            ? () {
                          // 1. Build object từ form
                          final newTask = formProvider.buildTask();
                          if (newTask != null) {
                            // 2. Gửi cho "Ông Trùm" TaskViewModel lưu db
                            context.read<TaskViewModel>().addTask(newTask);
                            // 3. Đóng màn hình
                            Navigator.pop(context);
                          }
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF393433),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}