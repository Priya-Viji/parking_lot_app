import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const Summary({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text("$label: $value", style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}