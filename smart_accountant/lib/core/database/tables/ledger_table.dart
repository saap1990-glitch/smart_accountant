import 'package:drift/drift.dart';

class Ledger extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get journalId => integer()();

  IntColumn get accountId => integer()();

  DateTimeColumn get date => dateTime()();

  RealColumn get debit => real().withDefault(const Constant(0))();

  RealColumn get credit => real().withDefault(const Constant(0))();

  RealColumn get balance => real().withDefault(const Constant(0))();

  TextColumn get description => text()();
}
