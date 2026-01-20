import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'folder.g.dart';

@HiveType(typeId: 0)
class Folder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int? iconCode;

  @HiveField(3)
  int? colorValue;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  Folder({
    required this.id,
    required this.title,
    this.iconCode,
    this.colorValue,
    required this.createdAt,
    required this.updatedAt,
  });


  IconData? get icon {
    if (iconCode == null) return null;
    return IconData(iconCode!, fontFamily: 'MaterialIcons');
  }

  Color? get backgroundColor {
    if (colorValue == null) return null;
    return Color(colorValue!);
  }
}