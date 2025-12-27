import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String title;
  final int counter;
  final Color? color;
  const HomeCard({super.key, required this.onTap,this.icon = Icons.folder, required this.title, this.counter = 0, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color ?? Colors.grey,),
              SizedBox(height: 16,),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Color(0xff121212), fontSize: 17),
                  children: [
                    TextSpan(
                      text: "$counter ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    WidgetSpan(
                      child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          title,
                          style: TextStyle(
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
      ),
    );
  }
}
