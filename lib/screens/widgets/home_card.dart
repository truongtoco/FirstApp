import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final int counter;
  final Color? color;

  const HomeCard({
    super.key,
    this.icon = Icons.folder,
    required this.title,
    this.counter = 0,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? Colors.grey),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xff121212), fontSize: 17),
                children: [
                  TextSpan(
                    text: "$counter ",
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  WidgetSpan(
                    child: Opacity(
                      opacity: 0.3,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff121212),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
