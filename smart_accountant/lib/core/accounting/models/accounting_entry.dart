import '../enums/entry_status.dart';
import 'accounting_line.dart';

class AccountingEntry {
  final DateTime date;
  final String reference;
  final String description;
  final EntryStatus status;
  final List<AccountingLine> lines;

  const AccountingEntry({
    required this.date,
    required this.reference,
    required this.description,
    required this.lines,
    this.status = EntryStatus.draft,
  });

  double get totalDebit => lines.fold(0, (sum, line) => sum + line.debit);

  double get totalCredit => lines.fold(0, (sum, line) => sum + line.credit);

  bool get isBalanced => totalDebit == totalCredit;

  int get linesCount => lines.length;
}
