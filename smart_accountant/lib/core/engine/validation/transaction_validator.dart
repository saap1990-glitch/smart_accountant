import '../accounting/journal_builder.dart';

class TransactionValidator {
  String? validate(JournalBuilder journal) {
    if (journal.lines.isEmpty) {
      return 'لا توجد أسطر في القيد';
    }

    if (!journal.isBalanced()) {
      return 'القيد غير متوازن';
    }

    for (final line in journal.lines) {
      if (line.accountId <= 0) {
        return 'رقم الحساب غير صحيح';
      }

      if (line.debit < 0 || line.credit < 0) {
        return 'القيم لا يمكن أن تكون سالبة';
      }

      if (line.debit > 0 && line.credit > 0) {
        return 'لا يمكن أن يكون السطر مدين ودائن في نفس الوقت';
      }
    }

    return null;
  }
}
