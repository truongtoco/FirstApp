import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/models/folder.dart';
import 'package:task_manager_app/models/task.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTaskController = TextEditingController(); // Controller cho subtask

  String? selectedFolderId;
  bool canSave = false;

  // --- Biến mới cho tính năng Subtask và Time ---
  bool isAddingSubtask = false; // Trạng thái checkbox subtask
  TimeOfDay? selectedTime;      // Lưu giờ đã chọn
  // ---------------------------------------------

  @override
  void initState() {
    super.initState();
    titleController.addListener(() {
      setState(() {
        canSave = titleController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    subTaskController.dispose();
    super.dispose();
  }

  // Hàm chọn giờ
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void handleSave() {
    if (!canSave) return;
    final uuid = const Uuid();
    final now = DateTime.now();

    // 1. Tìm đối tượng Folder từ ID (Logic giữ nguyên object như bạn muốn)
    final provider = context.read<TaskProvider>();
    Folder? selectedFolder;
    if (selectedFolderId != null) {
      try {
        selectedFolder = provider.folders.firstWhere((f) => f.id == selectedFolderId);
      } catch (e) {
        selectedFolder = null;
      }
    }

    // 2. Xử lý Subtask (Nếu có nhập)
    List<Task> subTasksList = [];
    if (isAddingSubtask && subTaskController.text.trim().isNotEmpty) {
      subTasksList.add(Task(
        id: uuid.v4(),
        title: subTaskController.text.trim(),
        createdAt: now,
        updatedAt: now,
      ));
    }

    // 3. Xử lý Thời gian (Ghép ngày hôm nay + giờ đã chọn)
    DateTime? scheduledDateTime;
    if (selectedTime != null) {
      scheduledDateTime = DateTime(
          now.year, now.month, now.day,
          selectedTime!.hour, selectedTime!.minute
      );
    }

    // 4. Tạo Task chính
    final newTask = Task(
      id: uuid.v4(),
      title: titleController.text.trim(),
      // Lưu ý: Nếu model bạn dùng folderId thì sửa dòng dưới thành folderId: selectedFolderId
      // Nếu model dùng object Folder thì dùng dòng này:
      folder: selectedFolder,
      createdAt: now,
      updatedAt: now,
      subTask: subTasksList,
      scheduledDate: scheduledDateTime, // Lưu giờ hẹn
    );

    provider.addTask(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final folders = context.select((TaskProvider p) => p.folders);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: keyboardHeight + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút đóng
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          // Input Tiêu đề Task
          TextField(
            controller: titleController,
            autofocus: true,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Write a new task...",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 10),

          // --- PHẦN SUBTASK ---
          InkWell(
            onTap: () {
              setState(() {
                isAddingSubtask = !isAddingSubtask;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    isAddingSubtask ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isAddingSubtask ? Colors.black : Colors.grey.shade400
                ),
                const SizedBox(width: 8),
                Text(
                    "Add subtask",
                    style: TextStyle(
                        color: isAddingSubtask ? Colors.black : Colors.grey.shade500,
                        fontSize: 16
                    )
                )
              ],
            ),
          ),

          // Nếu checkbox được tick thì hiện ô nhập subtask
          if (isAddingSubtask)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 32.0), // Thụt đầu dòng cho đẹp
              child: TextField(
                controller: subTaskController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: "Enter subtask...",
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Danh sách Folder
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: folders.map((folder) {
              final isSelected = selectedFolderId == folder.id;
              return ChoiceChip(
                label: Text(folder.title),
                labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 12
                ),
                selected: isSelected,
                selectedColor: folder.backgroundColor ?? Colors.black,
                backgroundColor: Colors.grey.shade100,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onSelected: (selected) {
                  setState(() {
                    selectedFolderId = selected ? folder.id : null;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // Thanh công cụ dưới cùng (Time + Save)
          Row(
            children: [
              // Nút Chọn Giờ
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: selectedTime != null ? Colors.black : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: selectedTime != null ? Colors.white : Colors.grey,
                        size: 20,
                      ),
                      // Nếu đã chọn giờ thì hiện text giờ ra
                      if (selectedTime != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          selectedTime!.format(context),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Nút Save
              Expanded(
                child: ElevatedButton(
                  onPressed: canSave ? handleSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF393433),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}