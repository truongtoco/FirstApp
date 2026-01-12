import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/screens/body/list_folder.dart';
import 'package:task_manager_app/screens/body/list_task.dart';
import 'package:task_manager_app/screens/widgets/add_task.dart';
import 'package:task_manager_app/screens/widgets/new_folder_screen.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 36),
            children: [
              const TextSpan(
                text: "Today ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              WidgetSpan(
                child: Opacity(
                  opacity: 0.3,
                  child: Text(
                    DateFormat('d MMM').format(DateTime.now()),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ListFolder(),
            // Nút Add New Folder
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: InkWell(
                splashColor: Colors.black12,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewFolderScreen(),
                    ),
                  );
                },

                child: Ink(
                  width: double.infinity,
                  child: DottedBorder(
                    options: const RoundedRectDottedBorderOptions(
                      radius: Radius.circular(12),
                      strokeWidth: 1.5,
                      color: Colors.grey,
                      dashPattern: [8, 5],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text(
                            "Add new folder",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Danh sách Task
            const ListTask()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF393433),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              builder: (context) {
                return const AddNewTask();
              });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}