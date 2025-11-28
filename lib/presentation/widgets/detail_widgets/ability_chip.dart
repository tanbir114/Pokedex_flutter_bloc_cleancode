import 'package:flutter/material.dart';

class AbilityChip extends StatelessWidget {
  final String name;
  final Color color;

  const AbilityChip({Key? key, required this.name, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(name),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    );
  }
}
