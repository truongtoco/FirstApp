import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/new_folder_provider.dart'; // Import Provider riêng

class NewFolderScreen extends StatelessWidget {
  const NewFolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap bằng ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => NewFolderProvider(),
      child: Consumer<NewFolderProvider>(
        builder: (context, provider, child) {
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'New Folder',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // --- INPUT NAME ---
                    TextField(
                      controller: provider.titleController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Folder name',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                    const Divider(),
                    const SizedBox(height: 15),

                    // --- ICON SELECTOR ---
                    const Text(
                      'Icon',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: provider.icons.map((icon) {
                        final isSelected = icon == provider.selectedIcon;
                        return GestureDetector(
                          onTap: () => provider.selectIcon(icon),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: isSelected
                                ? provider.selectedColor
                                : Colors.grey.shade100,
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.grey,
                              size: 20,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // --- COLOR SELECTOR ---
                    const Text(
                      'Color',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      children: provider.colors.map((color) {
                        final isSelected = color == provider.selectedColor;
                        return GestureDetector(
                          onTap: () => provider.selectColor(color),
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

                    // --- CREATE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => provider.saveFolder(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
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
        },
      ),
    );
  }
}