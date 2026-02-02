import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:uuid/uuid.dart';

class FolderService {
  // --- SINGLETON PATTERN ---
  static final FolderService _instance = FolderService._internal();
  factory FolderService() => _instance;
  FolderService._internal();

  late Box<Folder> _folderBox;

  // Mở Box
  Future<void> init() async {
    _folderBox = await Hive.openBox<Folder>('folders');
  }

  // Lấy toàn bộ danh sách Folder
  List<Folder> getAllFolders() {
    return _folderBox.values.toList().cast<Folder>();
  }

  // Lấy Folder theo ID
  Folder? getFolderById(String id) {
    return _folderBox.get(id);
  }

  Future<void> addFolder(Folder folder) async {
    await _folderBox.put(folder.id, folder);
  }
}