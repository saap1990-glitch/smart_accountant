import '../../errors/app_exception.dart';
import '../../errors/result.dart';

enum TransactionType {
  receipt, payment, journal, sale, purchase, transfer, inventory,
}

class JournalItem {
  final int accountId;
  final double debit;
  final double credit;
  final String? description;

  const JournalItem({
    required this.accountId,
    this.debit = 0,
    this.credit = 0,
    this.description,
  });
}

class TransactionContext {
  final TransactionType type;
  final DateTime date;
  final String? reference;
  final List<JournalItem> items;
  final String? currencyCode;
  final double exchangeRate;
  final Map<String, dynamic>? metadata;

  const TransactionContext({
    required this.type,
    required this.date,
    required this.items,
    this.reference,
    this.currencyCode = 'YER',
    this.exchangeRate = 1.0,
    this.metadata,
  });

  Result<void> validate() {
    if (items.isEmpty) {
      return const Failure(ValidationException('يجب إضافة بند واحد على الأقل'));
    }
    double totalDebit = 0, totalCredit = 0;
    for (final item in items) {
      totalDebit += item.debit;
      totalCredit += item.credit;
    }
    if ((totalDebit - totalCredit).abs() > 0.001) {
      return const Failure(ValidationException('يجب أن يتساوى مجموع المدين والدائن'));
    }
    return const Success(null);
  }
}
