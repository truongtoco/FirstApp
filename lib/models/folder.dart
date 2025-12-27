import 'dart:ui';

import 'package:flutter/material.dart';

class Folder {
  String id;
  String title;
  IconData? icon;
  Color? backgroundColor;
  DateTime createdAt;
  DateTime updatedAt;

  Folder({
    required this.id,
    required this.title,
    this.icon,
    this.backgroundColor,
    required this.createdAt,
    required this.updatedAt,
  });
}
