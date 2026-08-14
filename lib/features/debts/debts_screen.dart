import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../core/services/debts/debt_service.dart';

class DebtsScreen extends StatefulWidget {
  const DebtsScreen({super.key});

  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  final _debtService = GetIt.I<DebtService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الديون والتحصيل'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showAddDialog()),
        ],
      ),
      body: StreamBuilder<List<DebtRecord>>(
        stream: _debtService.debts,
        initialData: _debtService.allDebts,
        builder: (context, snapshot) {
          final debts = snapshot.data ?? [];
          if (debts.isEmpty) {
            return const Center(child: Text('لا توجد ديون'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ملخص
              Card(
                color: Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('إجمالي الديون: ${_debtService.totalUnpaid.toStringAsFixed(0)} ريال', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('المتأخر: ${_debtService.totalOverdue.toStringAsFixed(0)} ريال', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...debts.asMap().entries.map((entry) {
                final idx = entry.key;
                final debt = entry.value;
                final isOverdue = !debt.isPaid && DateTime.now().isAfter(debt.dueDate);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(isOverdue ? Icons.warning : Icons.schedule, color: isOverdue ? Colors.red : Colors.orange),
                    title: Text(debt.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('المبلغ: ${debt.amount.toStringAsFixed(0)} ريال | الاستحقاق: ${debt.dueDate.day}/${debt.dueDate.month}/${debt.dueDate.year}'),
                    trailing: debt.isPaid
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : IconButton(icon: const Icon(Icons.check), color: Colors.green, onPressed: () { _debtService.markPaid(idx); setState(() {}); }),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 30));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة دين'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم العميل')),
            const SizedBox(height: 8),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'المبلغ'), keyboardType: TextInputType.number),
            const SizedBox(height: 8),
            ListTile(
              title: Text('تاريخ الاستحقاق: ${dueDate.day}/${dueDate.month}/${dueDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(context: ctx, initialDate: dueDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (date != null) dueDate = date;
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && amountCtrl.text.isNotEmpty) {
                _debtService.addDebt(customerName: nameCtrl.text, amount: double.tryParse(amountCtrl.text) ?? 0, dueDate: dueDate);
                Navigator.pop(ctx);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
