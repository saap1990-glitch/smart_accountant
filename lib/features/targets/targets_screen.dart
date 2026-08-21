import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/targets/target_service.dart';

class TargetsScreen extends StatefulWidget {
  const TargetsScreen({super.key});

  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  final _service = GetIt.I<TargetService>();

  @override
  Widget build(BuildContext context) {
    final targets = _service.allTargets;
    final overall = _service.overallTarget;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأهداف والتارجت'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addTarget),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (overall.monthlyTarget > 0) ...[
            _TargetCard(target: overall, isOverall: true),
            const SizedBox(height: 16),
          ],
          if (targets.isNotEmpty) ...[
            Text('المندوبين', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...targets.map((t) => _TargetCard(target: t)),
          ] else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('لم يتم تحديد أهداف بعد\nاضغط + لإضافة هدف جديد', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }

  void _addTarget() {
    final nameCtrl = TextEditingController();
    final monthCtrl = TextEditingController();
    final yearCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة هدف جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم المندوب')),
              const SizedBox(height: 8),
              TextField(controller: monthCtrl, decoration: const InputDecoration(labelText: 'الهدف الشهري (ريال)'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: yearCtrl, decoration: const InputDecoration(labelText: 'الهدف السنوي (ريال)'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              final target = SalesTarget(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text,
                salespersonName: nameCtrl.text,
                monthlyTarget: double.tryParse(monthCtrl.text) ?? 0,
                yearlyTarget: double.tryParse(yearCtrl.text) ?? 0,
              );
              _service.setTarget(target);
              Navigator.pop(ctx);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إضافة الهدف ✅')));
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.target, this.isOverall = false});
  final SalesTarget target;
  final bool isOverall;

  @override
  Widget build(BuildContext context) {
    final percentage = target.monthPercentage.clamp(0, 100) / 100.0;
    final color = percentage >= 1.0 ? Colors.green : percentage >= 0.8 ? Colors.orange : Colors.teal;

    return Card(
      elevation: isOverall ? 2 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(target.name, style: TextStyle(fontSize: isOverall ? 20 : 16, fontWeight: FontWeight.bold)),
              Text('${(percentage * 100.0).toInt()}%', style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            _progressRow('شهري', target.achievedMonth, target.monthlyTarget, color),
            const SizedBox(height: 8),
            _progressRow('سنوي', target.achievedYear, target.yearlyTarget, Colors.blue),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('المتبقي شهرياً: ${target.monthRemaining.toStringAsFixed(0)} ريال', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              Text('متبقي ${target.monthDaysLeft} يوم', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _progressRow(String label, double achieved, double targetVal, Color color) {
    final pct = targetVal > 0 ? (achieved / targetVal).clamp(0.0, 1.0) : 0.0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$label: ${achieved.toStringAsFixed(0)} / ${targetVal.toStringAsFixed(0)}'),
      const SizedBox(height: 4),
      ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: pct, minHeight: 8, backgroundColor: Colors.grey.shade200, color: color)),
    ]);
  }
}
