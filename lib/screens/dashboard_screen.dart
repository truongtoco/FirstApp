import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thống Kê")),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.totalTasks == 0) {
            return const Center(child: Text("Chưa có công việc nào!"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== 1. THẺ TỔNG QUAN =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoCard("Tổng", provider.totalTasks, Colors.blue),
                    _infoCard("Xong", provider.completedTasks, Colors.green),
                    _infoCard("Chờ", provider.pendingTasks, Colors.orange),
                  ],
                ),

                const SizedBox(height: 30),
                const Text(
                  "Phân bố theo Folder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // ===== 2. BIỂU ĐỒ TRÒN =====
                SizedBox(
                  height: 250,
                  child: PieChart(
                    PieChartData(
                      sections: provider.stats.map((stat) {
                        return PieChartSectionData(
                          color: stat.color,
                          value: stat.count.toDouble(),
                          title: '${stat.count}',
                          radius: 60,
                          titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),

                // ===== 3. CHÚ THÍCH =====
                const SizedBox(height: 20),
                ...provider.stats.map(
                  (stat) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: stat.color,
                      radius: 8,
                    ),
                    title: Text(stat.folderName),
                    trailing: Text("${stat.count} task"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "$value",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
