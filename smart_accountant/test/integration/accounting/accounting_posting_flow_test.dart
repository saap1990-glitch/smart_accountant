import 'package:flutter_test/flutter_test.dart';

import 'package:smart_accountant/core/database/app_database.dart';
import 'package:smart_accountant/core/services/accounting/accounting_service.dart';
import 'package:smart_accountant/core/accounting/models/accounting_entry.dart';
import 'package:smart_accountant/core/accounting/models/accounting_line.dart';

import 'package:smart_accountant/core/database/app_database.dart';

void main() {
  late AppDatabase db;
  late AccountingService service;

  setUp(() {
    db = AppDatabase();
    service = AccountingService(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('Complete accounting posting flow', () async {
    final entry = AccountingEntry(
      date: DateTime(2026, 1, 1),
      reference: 'OPEN-001',
      description: 'Opening balance',
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

    final id = await service.postEntry(
      entry: entry,
      currency: 'YER',
      exchangeRate: 1,
    );

    expect(id, greaterThan(0));

    final journals = await db.select(db.journalEntries).get();

    expect(journals.length, 1);

    final lines = await db.select(db.journalLines).get();

    expect(lines.length, 2);

    final ledger = await db.select(db.ledger).get();

    expect(ledger.length, 2);

    final balances = await db.select(db.balances).get();

    expect(balances.length, 2);
  });
}
