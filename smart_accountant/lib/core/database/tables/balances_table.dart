import 'package:drift/drift.dart';

class Balances extends Table {
  IntColumn get accountId => integer()();

  TextColumn get currency => text()();

  RealColumn get debitTotal => real().withDefault(const Constant(0))();

  RealColumn get creditTotal => real().withDefault(const Constant(0))();

  RealColumn get balance => real().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {accountId, currency};
}
