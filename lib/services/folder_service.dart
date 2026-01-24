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

  // Mở Box và tạo data mẫu
  Future<void> init() async {
    _folderBox = await Hive.openBox<Folder>('folders');

    // Nếu box rỗng , tạo các folder mặc định
    if (_folderBox.isEmpty) {
      await _createDefaultFolders();
    }
  }

  // Lấy toàn bộ danh sách Folder
  List<Folder> getAllFolders() {
    return _folderBox.values.toList().cast<Folder>();
  }

  // Lấy Folder theo ID
  Folder? getFolderById(String id) {
    return _folderBox.get(id);
  }

  // --- TẠO DATA MẪU ---
  Future<void> _createDefaultFolders() async {
    final uuid = const Uuid();

    // Tạo danh sách folder mặc định với IconCode và ColorValue
    final defaultFolders = [
      Folder(
        id: uuid.v4(),
        title: "Health",
        iconCode: Icons.favorite.codePoint,
        colorValue: const Color(0xff7990F8).value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "Work",
        iconCode: Icons.work.codePoint,
        colorValue: const Color(0xff46CF8B).value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "Mental Health",
        iconCode: Icons.spa.codePoint,
        colorValue: const Color(0xffBC5EAD).value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Folder(
        id: uuid.v4(),
        title: "Others",
        iconCode: Icons.folder.codePoint,
        colorValue: const Color(0xff908986).value,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    // Lưu từng folder vào Box
    for (var folder in defaultFolders) {
      await _folderBox.put(folder.id, folder);
    }
  }

  Future<void> addFolder(Folder folder) async {
    await _folderBox.put(folder.id, folder);
  }

  Future<void> deleteFolder(String id) async {
    if (!_folderBox.isOpen) {
      _folderBox = await Hive.openBox<Folder>('folders');
    }

    await _folderBox.delete(id);
  }
}
