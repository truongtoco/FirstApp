import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/folder_task_screen.dart';
import 'package:task_manager_app/screens/widgets/home_card.dart';

class ListFolder extends StatelessWidget {
  const ListFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(22),
          shrinkWrap: true,
          itemCount: provider.folders.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            final folder = provider.folders[index];

            return HomeCard(
              title: folder.title,
              icon: folder.icon,
              color: folder.backgroundColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FolderTaskScreen(folder: folder),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
