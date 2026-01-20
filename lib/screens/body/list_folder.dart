import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/screens/widgets/home_card.dart';
import '../../providers/task_provider.dart';

class ListFolder extends StatelessWidget {
  const ListFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(22),
          shrinkWrap: true,
          itemCount: viewModel.folders.length,
          itemBuilder: (context, index) {
            final folder = viewModel.folders[index];
            return HomeCard(
              onTap: () {},
              title: folder.title,
              icon: folder.icon,
              color: folder.backgroundColor,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.7,
          ),
        );
      },
    );
  }
}