import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/company_table.dart';
import 'tables/settings_table.dart';
import 'tables/currencies_table.dart';
import 'tables/exchange_rates_table.dart';
import 'tables/accounts_table.dart';
import 'tables/system_accounts_table.dart';
import 'tables/account_rules_table.dart';
import 'tables/account_links_table.dart';
import 'tables/journal_entries_table.dart';
import 'tables/journal_lines_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Companies,
    Settings,
    Currencies,
    ExchangeRates,
    Accounts,
    SystemAccounts,
    AccountRules,
    AccountLinks,
    JournalEntries,
    JournalLines,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },

    beforeOpen: (details) async {
      // سيتم هنا تشغيل:
      // Seed Engine
      // فحص الإعدادات
      // التهيئة الأولى
    },
  );
}
