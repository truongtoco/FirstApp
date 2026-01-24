import 'package:flutter/material.dart';

class NormalCheckbox extends StatelessWidget {
  final bool value;
  final Future<void> Function() onChanged;

  const NormalCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onChanged,
      child: Icon(
        value ? Icons.check_box : Icons.check_box_outline_blank,
        color: value ? Colors.blue : Colors.grey.shade400,
        size: 22,
      ),
    );
  }
}
