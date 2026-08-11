import 'package:drift/drift.dart';
import 'accounts_table.dart';

class AccountLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get linkType => text()();
  TextColumn get linkKey => text()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
