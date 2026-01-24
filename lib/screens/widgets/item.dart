import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_app/models/task.dart';

class Item extends StatelessWidget {
  final Task task;
  const Item({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        task.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
