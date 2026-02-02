import 'package:flutter/material.dart';

class FolderStat {
  final String folderName;
  final int count;       // Số lượng task
  final Color color;     // Màu của folder

  FolderStat({
    required this.folderName,
    required this.count,
    required this.color,
  });
}