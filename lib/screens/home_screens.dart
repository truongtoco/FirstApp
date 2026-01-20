import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/screens/body/list_folder.dart';
import 'package:task_manager_app/screens/body/list_task.dart';
import 'package:task_manager_app/screens/newtask.dart';
import 'package:task_manager_app/screens/newfolder.dart';


class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 36),
            children: [
              TextSpan(
                text: "Today ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              WidgetSpan(
                child: Opacity(
                  opacity: 0.3,
                  child: Text(
                    DateFormat('d MMM').format(DateTime.now()),
                    style: TextStyle(
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
            ListFolder(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: InkWell(
                splashColor: Colors.black12,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showDialog(
                    context: context,

                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const NewFolderScreen(),
                      );
                    },
                  );
                },

                child: Ink(
                  width: double.infinity,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(12),
                      strokeWidth: 1.5,
                      color: Colors.grey,
                      dashPattern: [8, 5],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text(
                            "Add new folder",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ListTask(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF393433),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewTaskScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
