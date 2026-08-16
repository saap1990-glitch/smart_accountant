import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/accounts_table.dart';
import 'tables/customers_table.dart';
import 'tables/suppliers_table.dart';
import 'tables/items_table.dart';
import 'tables/units_table.dart';
import 'tables/warehouses_table.dart';
import 'tables/banks_table.dart';
import 'tables/cash_boxes_table.dart';
import 'tables/wallets_table.dart';
import 'tables/exchange_companies_table.dart';
import 'tables/currencies_table.dart';
import 'tables/journal_entries_table.dart';
import 'tables/journal_lines_table.dart';
import 'tables/ledger_table.dart';
import 'tables/inventory_transactions_table.dart';
import 'tables/settings_table.dart';
import 'tables/company_table.dart';
import 'tables/account_links_table.dart';
import 'tables/system_accounts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Customers,
    Suppliers,
    Items,
    Units,
    Warehouses,
    Banks,
    CashBoxes,
    Wallets,
    ExchangeCompanies,
    Currencies,
    JournalEntries,
    JournalLines,
    Ledger,
    InventoryTransactions,
    Settings,
    Company,
    AccountLinks,
    SystemAccounts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'smart_accountant_db'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(accounts, accounts.openingBalance);

        await m.addColumn(accounts, accounts.openingBalanceNature);
      }
    },
  );
}
