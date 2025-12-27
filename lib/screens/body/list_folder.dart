import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/screens/widgets/home_card.dart';

class ListFolder extends StatelessWidget {
  const ListFolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, value, child) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(22),
          shrinkWrap: true,
          itemCount: value.folders.length,
          itemBuilder: (context, index) {
            final folder = value.folders[index];
            return HomeCard(
              onTap: () {},
              title: folder.title,
              icon: folder.icon,
              color: folder.backgroundColor,
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
