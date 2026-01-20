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
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.folders.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text("No folders"),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(22),
          itemCount: provider.folders.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            final folder = provider.folders[index];

            ///  counter tự update
            return Selector<TaskProvider, int>(
              selector: (_, p) =>
                  p.tasks.where((t) => t.folder?.id == folder.id).length,
              builder: (context, count, _) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FolderTaskScreen(folder: folder),
                      ),
                    );
                  },
                  onLongPress: () async {
                    final confirm = await showModalBottomSheet<bool>(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Delete Folder',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () => Navigator.pop(context, true),
                            ),
                            ListTile(
                              leading: const Icon(Icons.close),
                              title: const Text('Cancel'),
                              onTap: () => Navigator.pop(context, false),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (confirm == true) {
                      await provider.deleteFolder(folder.id);
                    }
                  },
                  child: HomeCard(
                    title: folder.title,
                    icon: folder.icon,
                    color: folder.backgroundColor,
                    counter: count,
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
