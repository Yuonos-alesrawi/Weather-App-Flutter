import 'package:flutter/material.dart';

class HourlyForcastItem extends StatelessWidget {
  final IconData icon;
  final String time;
  final String tp;

  const HourlyForcastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.tp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(
              maxLines:1,
              overflow: TextOverflow.ellipsis,
              time,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 30),
            const SizedBox(height: 8),
            Text(tp, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
