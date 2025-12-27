import 'package:flutter/material.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Folder> _folders = [];

  List<Task> get tasks => _tasks;

  List<Folder> get folders => _folders;

  bool test = false;

  TaskProvider() {
    init();
  }

  Future init() async {
    await Future.delayed(Duration(seconds: 1));
    final uuid = Uuid();
    final defaultFolders = [
      Folder(
        id: uuid.v4(),
        title: "Health",
        icon: Icons.favorite,
        backgroundColor: Color(0xff7990F8),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "Work",
        icon: Icons.work,
        backgroundColor: Color(0xff46CF8B),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "mental Health",
        icon: Icons.spa,
        backgroundColor: Color(0xffBC5EAD),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "Others",
        icon: Icons.folder,
        backgroundColor: Color(0xff908986),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    final defaultTasks = [
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        folder: Folder(
          id: uuid.v4(),
          title: "Health",
          icon: Icons.favorite,
          backgroundColor: Color(0xff7990F8),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        subTask: [
          Task(
            id: uuid.v4(),
            title: "Drink 8 glasses of water",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Task(
            id: uuid.v4(),
            title: "Drink 8 glasses of water",
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        id: uuid.v4(),
        title: "Drink 8 glasses of water",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    _folders.addAll(defaultFolders);
    _tasks.addAll(defaultTasks);
    notifyListeners();
  }

  void changeTaskStatus() {
    test = !test;
    notifyListeners();
  }
}
