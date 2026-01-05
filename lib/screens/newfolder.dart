import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class NewFolderScreen extends StatefulWidget {
  const NewFolderScreen({super.key});

  @override
  State<NewFolderScreen> createState() => _NewFolderScreenState();
}

class _NewFolderScreenState extends State<NewFolderScreen> {
  final _titleController = TextEditingController();

  IconData _selectedIcon = Icons.folder;
  Color _selectedColor = Colors.blue;

  final _icons = [
    Icons.folder,
    Icons.work,
    Icons.favorite,
    Icons.spa,
    Icons.school,
    Icons.home,
  ];

  final _colors = [
    Color(0xff7990F8),
    Color(0xff46CF8B),
    Color(0xffBC5EAD),
    Color(0xffF8A44C),
    Color(0xff908986),
    Color(0xffF27979),
  ];

  void _saveFolder() {
    if (_titleController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final folder = Folder(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      icon: _selectedIcon,
      backgroundColor: _selectedColor,
      createdAt: now,
      updatedAt: now,
    );

    context.read<TaskProvider>().addFolder(folder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Folder', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Folder name',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            const Text('Icon', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _icons.map((icon) {
                final isSelected = icon == _selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: isSelected
                        ? _selectedColor
                        : Colors.grey.shade200,
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _colors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
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

            const Spacer(),

            SafeArea(
              child: GestureDetector(
                onTap: _saveFolder,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Create Folder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
