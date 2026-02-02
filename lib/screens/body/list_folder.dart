import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/providers/task_provider.dart'; // Import ViewModel của Task

class ListFolder extends StatelessWidget {
  const ListFolder({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Lắng nghe Box Folder để vẽ danh sách Folder
    return ValueListenableBuilder<Box<Folder>>(
      valueListenable: Hive.box<Folder>('folders').listenable(),
      builder: (context, box, _) {
        final folders = box.values.toList(); // Lấy danh sách Folder

        if (folders.isEmpty) {
          return const Center(child: Text("Chưa có thư mục nào"));
        }

        // 2. GridView hiển thị Folder
        return GridView.builder(
          shrinkWrap: true, // Quan trọng để nằm trong SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(), // Không cho cuộn riêng
          padding: const EdgeInsets.symmetric(horizontal: 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5, // Tỷ lệ chiều rộng/cao của thẻ
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];

            // 3. Dùng Consumer để lấy danh sách Task và ĐẾM
            return Consumer<TaskViewModel>(
              builder: (context, taskViewModel, child) {
                // Logic đếm: Lọc ra những task nào có folderId trùng với folder hiện tại
                // Lưu ý: task.folder là Object, nên so sánh id hoặc title
                final taskCount = taskViewModel.tasks.where((task) {
                  return task.folder?.id == folder.id;
                }).length;

                return _buildFolderCard(folder, taskCount);
              },
            );
          },
        );
      },
    );
  }

  // Widget con để vẽ thẻ Folder
  Widget _buildFolderCard(Folder folder, int count) {
    return Container(
      decoration: BoxDecoration(
        color: folder.backgroundColor?.withOpacity(0.2) ?? Colors.grey[100], // Màu nền nhạt
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            folder.icon ?? Icons.folder,
            color: folder.backgroundColor ?? Colors.grey,
            size: 28,
          ),
          const Spacer(),

          // Số lượng Task (Đã tính toán ở trên)
          Text(
            "$count", // <--- SỐ LƯỢNG SẼ HIỆN Ở ĐÂY
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Tên Folder
          Text(
            folder.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}