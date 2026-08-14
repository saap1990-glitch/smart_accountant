import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/inventory/inventory_count_service.dart';

class YearCloseScreen extends StatefulWidget {
  const YearCloseScreen({super.key});

  @override
  State<YearCloseScreen> createState() => _YearCloseScreenState();
}

class _YearCloseScreenState extends State<YearCloseScreen> {
  final _countService = GetIt.I<InventoryCountService>();
  bool _loading = false;
  Map<String, dynamic>? _result;

  Future<void> _closeYear() async {
    setState(() => _loading = true);
    final result = await _countService.closeYear();
    setState(() {
      _loading = false;
      _result = result;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ تم الإغلاق السنوي')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإغلاق السنوي')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              Text('الإغلاق السنوي ${DateTime.now().year}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('سيتم تصفير حسابات الإيرادات والمصروفات وترحيل النتيجة إلى الأرباح المحتجزة', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              if (_loading)
                const CircularProgressIndicator()
              else if (_result != null)
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(children: [
                      Text('الإيرادات: ${_result!['totalRevenues']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('المصروفات: ${_result!['totalExpenses']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('صافي الدخل: ${_result!['netIncome']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    ]),
                  ),
                )
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock),
                  label: const Text('تنفيذ الإغلاق السنوي'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                  onPressed: _closeYear,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
