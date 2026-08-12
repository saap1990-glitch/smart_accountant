import 'package:drift/drift.dart';
import 'accounts_table.dart';

class AccountLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get module => text()(); // customers, suppliers, banks, cash_boxes, wallets, exchange_companies, warehouses
  TextColumn get entityType => text()(); // Customer, Supplier, Bank, CashBox, Wallet, ExchangeCompany, Warehouse
  TextColumn get entityId => text()(); // ID الخاص بالكيان
  IntColumn get accountId => integer().references(Accounts, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
