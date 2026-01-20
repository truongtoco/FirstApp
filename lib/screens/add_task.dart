import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:task_manager_app/providers/new_task_provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newTask = context.watch<NewTaskProvider>();
    final taskProvider = context.watch<TaskProvider>();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              TextField(
                controller: newTask.titleController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write a new task...',
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 16),

              Column(
                children: List.generate(
                  newTask.subtaskControllers.length,
                  (index) => Row(
                    children: [
                      const Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: newTask.subtaskControllers[index],
                          decoration: const InputDecoration(
                            hintText: 'Subtask',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => newTask.removeSubtask(index),
                      ),
                    ],
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: newTask.addSubtask,
                icon: const Icon(Icons.add, color: Colors.grey),
                label: const Text(
                  'Add subtask',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Folder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: taskProvider.folders.map((folder) {
                  final isSelected = newTask.selectedFolder?.id == folder.id;

                  return ChoiceChip(
                    label: Text(folder.title),
                    selected: isSelected,
                    onSelected: (_) => newTask.selectFolder(folder),
                    selectedColor: folder.backgroundColor!.withOpacity(0.25),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? folder.backgroundColor : Colors.black,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              if (newTask.selectedDateTime != null)
                Text(
                  DateFormat(
                    'dd/MM/yyyy – HH:mm',
                  ).format(newTask.selectedDateTime!),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: newTask.selectedDateTime ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date == null) return;

                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      newTask.selectedDateTime ?? DateTime.now(),
                    ),
                  );
                  if (time == null) return;

                  newTask.selectDateTime(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                  );
                },
              ),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: taskProvider.isLoading
                        ? null
                        : () async {
                            final task = newTask.buildTask();

                            if (task == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter title & folder'),
                                ),
                              );
                              return;
                            }

                            await taskProvider.addTask(task);
                            newTask.clear();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: taskProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
