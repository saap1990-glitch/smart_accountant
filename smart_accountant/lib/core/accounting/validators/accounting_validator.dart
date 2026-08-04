import '../models/accounting_entry.dart';

class AccountingValidator {
  const AccountingValidator();

  void validate(AccountingEntry entry) {
    if (entry.lines.isEmpty) {
      throw Exception('Accounting entry must contain lines');
    }

    if (!entry.isBalanced) {
      throw Exception(
        'Accounting entry is not balanced: '
        '${entry.totalDebit} != ${entry.totalCredit}',
      );
    }

    for (final line in entry.lines) {
      if (line.debit < 0 || line.credit < 0) {
        throw Exception('Debit or credit cannot be negative');
      }

      if (line.debit == 0 && line.credit == 0) {
        throw Exception('Empty accounting line amount');
      }
    }
  }
}
