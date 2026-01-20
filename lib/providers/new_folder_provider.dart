import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class NewFolderProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();

  IconData selectedIcon = Icons.folder;
  Color selectedColor = const Color(0xff7990F8);

  final List<IconData> icons = [
    Icons.folder, Icons.work, Icons.favorite,
    Icons.spa, Icons.school, Icons.home,
  ];

  final List<Color> colors = [
    const Color(0xff7990F8), const Color(0xff46CF8B),
    const Color(0xffBC5EAD), const Color(0xffF8A44C),
    const Color(0xff908986), const Color(0xffF27979),
  ];

  void selectIcon(IconData icon) {
    selectedIcon = icon;
    notifyListeners();
  }

  void selectColor(Color color) {
    selectedColor = color;
    notifyListeners();
  }

  void saveFolder(BuildContext context) {
    if (titleController.text.trim().isEmpty) return;

    final now = DateTime.now();

    // Tạo object Folder (Convert Icon/Color sang int để lưu Hive)
    final newFolder = Folder(
      id: const Uuid().v4(),
      title: titleController.text.trim(),
      iconCode: selectedIcon.codePoint,
      colorValue: selectedColor.value,
      createdAt: now,
      updatedAt: now,
    );

    // Lưu vào Database
    context.read<TaskViewModel>().addFolder(newFolder);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}