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
import 'tables/ledger_table.dart';
import 'tables/balances_table.dart';
import 'seeds/financial_account_seed.dart';
import 'tables/financial_accounts_table.dart';
import 'seeds/account_seed.dart';
import 'tables/cash_boxes_table.dart';import 'tables/banks_table.dart';import 'tables/wallets_table.dart';import 'tables/exchange_companies_table.dart';import 'tables/customers_table.dart';import 'tables/suppliers_table.dart';import 'tables/categories_table.dart';import 'tables/units_table.dart';import 'tables/warehouses_table.dart';import 'tables/items_table.dart';import 'tables/inventory_balances_table.dart';import 'tables/inventory_transactions_table.dart';
import 'tables/documents_table.dart';import 'tables/document_lines_table.dart';
import 'tables/cash_boxes_table.dart';

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
    Ledger,
    Balances,
    FinancialAccounts,
CashBoxes,    Banks,    Wallets,    ExchangeCompanies,    Customers,    Suppliers,    Categories,    Units,    Warehouses,    Items,    InventoryBalances,    InventoryTransactions,
Documents,    DocumentLines,
    CashBoxes,
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
