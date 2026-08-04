import 'package:flutter_test/flutter_test.dart';

import 'package:smart_accountant/core/accounting/models/accounting_entry.dart';
import 'package:smart_accountant/core/accounting/models/accounting_line.dart';
import 'package:smart_accountant/core/accounting/enums/entry_status.dart';

void main() {
  test('Accounting entry should be balanced', () {
    final entry = AccountingEntry(
      date: DateTime(2026, 1, 1),
      reference: 'TEST-001',
      description: 'Opening entry',
      status: EntryStatus.draft,
      lines: const [
        AccountingLine(
          accountId: 1,
          currencyCode: 'YER',
          exchangeRate: 1,
          debit: 1000,
          credit: 0,
          description: 'Cash',
        ),
        AccountingLine(
          accountId: 2,
          currencyCode: 'YER',
          exchangeRate: 1,
          debit: 0,
          credit: 1000,
          description: 'Capital',
        ),
      ],
    );

    expect(entry.isBalanced, true);
    expect(entry.totalDebit, 1000);
    expect(entry.totalCredit, 1000);
  });
}
