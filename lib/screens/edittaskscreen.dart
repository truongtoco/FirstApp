import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:task_manager_app/models/task.dart';

import 'package:task_manager_app/providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _uuid = const Uuid();

  late TextEditingController titleCtrl;

  String? selectedFolderId;
  DateTime? remindAt;
  List<Task> subTasks = [];

  bool _initialized = false;
  late Task _originTask;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: remindAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(remindAt ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      remindAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save(TaskProvider provider) {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) return;

    _originTask
      ..title = title
      ..folder = selectedFolderId == null
          ? null
          : provider.folders.firstWhere((f) => f.id == selectedFolderId)
      ..remindAt = remindAt
      ..subTasks = subTasks
      ..updatedAt = DateTime.now();

    provider.updateTask(_originTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final task = provider.getTaskById(widget.taskId);

        if (task == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_initialized) {
          _originTask = task;
          titleCtrl.text = task.title;
          selectedFolderId = task.folder?.id;
          remindAt = task.remindAt;
          subTasks = task.subTasks.map((e) => e.copyWith()).toList();
          _initialized = true;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Task'),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _save(provider),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: provider.folders.any((f) => f.id == selectedFolderId)
                    ? selectedFolderId
                    : null,
                items: provider.folders
                    .map(
                      (f) => DropdownMenuItem<String>(
                        value: f.id,
                        child: Text(f.title),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedFolderId = v),
                decoration: const InputDecoration(
                  labelText: 'Folder',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// REMIND
              ListTile(
                onTap: _pickDateTime,
                leading: const Icon(Icons.access_time),
                title: const Text('Remind at'),
                subtitle: Text(
                  remindAt == null
                      ? 'Not set'
                      : DateFormat('dd MMM yyyy • h:mm a').format(remindAt!),
                ),
                trailing: remindAt != null
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => remindAt = null),
                      )
                    : null,
              ),

              const Divider(height: 32),

              const Text(
                'Subtasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              ...subTasks.map((sub) {
                return ListTile(
                  leading: Checkbox(
                    value: sub.isCompleted,
                    onChanged: (v) {
                      setState(() {
                        final i = subTasks.indexWhere((e) => e.id == sub.id);
                        subTasks[i] = sub.copyWith(isCompleted: v ?? false);
                      });
                    },
                  ),

                  title: TextFormField(
                    initialValue: sub.title,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên subtask...',
                      border: InputBorder.none,
                    ),
                    onChanged: (newText) {
                      final i = subTasks.indexWhere((e) => e.id == sub.id);
                      subTasks[i] = subTasks[i].copyWith(title: newText);
                    },
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => subTasks.remove(sub)),
                  ),
                );
              }),

              TextButton.icon(
                onPressed: () {
                  setState(() {
                    subTasks.add(
                      Task(
                        id: _uuid.v4(),
                        title: 'New subtask',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.add),
                label: const Text('Add subtask'),
              ),
            ],
          ),
        );
      },
    );
  }
}
