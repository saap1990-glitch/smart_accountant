import 'package:drift/drift.dart';
import 'accounts_table.dart';

class Balances extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get currencyCode => text().withDefault(const Constant('YER'))();
  TextColumn get debitTotal => text().withDefault(const Constant('0'))();
  TextColumn get creditTotal => text().withDefault(const Constant('0'))();
  TextColumn get balance => text().withDefault(const Constant('0'))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
