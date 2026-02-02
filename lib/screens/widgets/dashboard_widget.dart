import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/task_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, viewModel, child) {
        final total = viewModel.totalTasks;
        final completed = viewModel.completedTasksCount;
        final pending = viewModel.pendingTasksCount;
        final percent =
            (viewModel.completionPercentage * 100).toStringAsFixed(0);
        final folderStats = viewModel.tasksPerFolder;

        if (total == 0) {
          return const SizedBox(); // Ẩn dashboard nếu chưa có task nào
        }

        return Container(
          margin: const EdgeInsets.all(22),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF393433), // Màu nền tối
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$percent% Done",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // CHART & STATS ROW
              Row(
                children: [
                  // 1. BIỂU ĐỒ TRÒN
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _buildChartSections(folderStats),
                          ),
                        ),
                        // Số tổng ở giữa biểu đồ
                        Center(
                          child: Text(
                            total.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 2. THÔNG TIN CHI TIẾT
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatItem(
                          color: const Color(0xFF46CF8B), // Màu xanh lá
                          label: "Completed",
                          count: completed,
                        ),
                        const SizedBox(height: 10),
                        _buildStatItem(
                          color: const Color(0xFFF8A44C), // Màu cam
                          label: "Pending",
                          count: pending,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm tạo các phần của biểu đồ tròn từ dữ liệu Folder
  List<PieChartSectionData> _buildChartSections(Map<dynamic, int> stats) {
    if (stats.isEmpty) {
      // Nếu chưa có task, hiển thị 1 vòng tròn xám
      return [
        PieChartSectionData(
          color: Colors.grey.withOpacity(0.2),
          value: 100,
          radius: 15,
          showTitle: false,
        )
      ];
    }

    return stats.entries.map((entry) {
      final folder = entry.key;
      final count = entry.value;

      // Lấy màu từ Folder (nếu folder ảo 'other' thì dùng màu xám)
      final color = folder.id == 'other'
          ? const Color(0xFF9E9E9E)
          : (folder.backgroundColor ?? Colors.blue);

      return PieChartSectionData(
        color: color,
        value: count.toDouble(),
        radius: 18, // Độ dày của vòng tròn
        showTitle: false,
      );
    }).toList();
  }

  // Widget hiển thị dòng chú thích (Legend)
  Widget _buildStatItem(
      {required Color color, required String label, required int count}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
