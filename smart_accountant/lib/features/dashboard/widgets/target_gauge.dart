import 'package:flutter/material.dart';
import '../../../core/services/targets/target_service.dart';

class TargetGauge extends StatelessWidget {
  final SalesTarget target;
  const TargetGauge({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    final percentage = target.monthPercentage.clamp(0, 100) / 100;
    final color = percentage >= 1
        ? Colors.green
        : percentage >= 0.8
            ? Colors.orange
            : Colors.teal;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('🎯 الهدف الشهري', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('${percentage.toStringAsFixed(0)}%'),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('المحقق: ${target.achievedMonth.toStringAsFixed(0)} ريال'),
                Text('المتبقي: ${target.monthRemaining.toStringAsFixed(0)} ريال'),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'متبقي ${target.monthDaysLeft} يوم',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
