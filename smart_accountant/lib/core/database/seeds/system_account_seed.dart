import 'package:drift/drift.dart';

import '../app_database.dart';

class SystemAccountSeed {
  static Future<void> run(AppDatabase db) async {
    final exists = await db.select(db.systemAccounts).get();

    if (exists.isNotEmpty) {
      return;
    }

    final accounts = await db.select(db.accounts).get();

    int? find(String number) {
      final account = accounts
          .where((a) => a.accountNumber == number)
          .firstOrNull;

      return account?.id;
    }

    final items = <SystemAccountsCompanion>[
      if (find('1105') != null)
        SystemAccountsCompanion.insert(
          key: 'CUSTOMERS',

          accountId: find('1105')!,

          description: const Value('حساب العملاء'),
        ),

      if (find('2101') != null)
        SystemAccountsCompanion.insert(
          key: 'SUPPLIERS',

          accountId: find('2101')!,

          description: const Value('حساب الموردين'),
        ),

      if (find('1102') != null)
        SystemAccountsCompanion.insert(
          key: 'BANKS',

          accountId: find('1102')!,

          description: const Value('حسابات البنوك'),
        ),

      if (find('1103') != null)
        SystemAccountsCompanion.insert(
          key: 'EXCHANGE_COMPANIES',

          accountId: find('1103')!,

          description: const Value('شركات الصرافة'),
        ),

      if (find('1104') != null)
        SystemAccountsCompanion.insert(
          key: 'WALLETS',

          accountId: find('1104')!,

          description: const Value('المحافظ الإلكترونية'),
        ),
    ];

    await db.batch((batch) {
      batch.insertAll(db.systemAccounts, items);
    });
  }
}
