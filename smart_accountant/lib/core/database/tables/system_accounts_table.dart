import 'package:drift/drift.dart';
import 'accounts_table.dart';

class SystemAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get systemCode => text().unique()(); // cash_default, bank_default, sales_default, purchase_default, inventory_default, customer_parent, supplier_parent, exchange_parent, wallet_parent
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
