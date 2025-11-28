import 'package:flutter/material.dart';

class StatProgressBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const StatProgressBar({
    Key? key,
    required this.label,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Max value for a single stat in Pokémon is around 255. We use 150 for visualization scaling.
    final double normalizedValue = value / 150;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Label (e.g., HP)
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
            ),
          ),

          // Value (e.g., 45)
          SizedBox(
            width: 30,
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),

          // Progress Bar
          Expanded(
            child: LinearProgressIndicator(
              value: normalizedValue > 1.0
                  ? 1.0
                  : normalizedValue, // Cap at 100%
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
