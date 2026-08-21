import 'dart:async';

class DebtRecord {

  DebtRecord({required this.customerName, required this.amount, required this.dueDate, this.isPaid = false, this.notes});
  final String customerName;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;
  final String? notes;
}

class DebtService {
  final List<DebtRecord> _debts = [];
  final _controller = StreamController<List<DebtRecord>>.broadcast();

  Stream<List<DebtRecord>> get debts => _controller.stream;
  List<DebtRecord> get allDebts => List.unmodifiable(_debts);
  List<DebtRecord> get unpaidDebts => _debts.where((d) => !d.isPaid).toList();
  List<DebtRecord> get overdueDebts => _debts.where((d) => !d.isPaid && DateTime.now().isAfter(d.dueDate)).toList();
  double get totalUnpaid => unpaidDebts.fold(0, (sum, d) => sum + d.amount);
  double get totalOverdue => overdueDebts.fold(0, (sum, d) => sum + d.amount);

  void addDebt({required String customerName, required double amount, required DateTime dueDate, String? notes}) {
    _debts.add(DebtRecord(customerName: customerName, amount: amount, dueDate: dueDate, notes: notes));
    _controller.add(allDebts);
  }

  void markPaid(int index) {
    if (index < _debts.length) {
      _debts[index] = DebtRecord(customerName: _debts[index].customerName, amount: _debts[index].amount, dueDate: _debts[index].dueDate, isPaid: true, notes: _debts[index].notes);
      _controller.add(allDebts);
    }
  }

  String getDebtAlert() {
    if (overdueDebts.isNotEmpty) return '⚠️ لديك ${overdueDebts.length} ديون متأخرة بقيمة ${totalOverdue.toStringAsFixed(0)} ريال';
    return '';
  }

  void dispose() => _controller.close();
}
