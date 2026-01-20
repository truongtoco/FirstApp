import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/new_folder_provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class NewFolderScreen extends StatelessWidget {
  const NewFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folderForm = context.watch<NewFolderProvider>();
    final taskProvider = context.read<TaskProvider>();

    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'New Folder',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              /// TITLE
              TextField(
                controller: folderForm.titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Folder name',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Divider(),
              const SizedBox(height: 16),

              /// ICONS
              const Text(
                'Icon',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 12,
                children: folderForm.icons.map((icon) {
                  final isSelected = icon == folderForm.selectedIcon;
                  return GestureDetector(
                    onTap: () => folderForm.selectIcon(icon),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: isSelected
                          ? folderForm.selectedColor
                          : Colors.grey.shade200,
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// COLORS
              const Text(
                'Color',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 12,
                children: folderForm.colors.map((color) {
                  final isSelected = color == folderForm.selectedColor;
                  return GestureDetector(
                    onTap: () => folderForm.selectColor(color),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              /// SAVE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final title = folderForm.titleController.text.trim();
                    if (title.isEmpty) return;

                    await taskProvider.createFolder(
                      title: title,
                      icon: folderForm.selectedIcon,
                      color: folderForm.selectedColor,
                    );

                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Folder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
