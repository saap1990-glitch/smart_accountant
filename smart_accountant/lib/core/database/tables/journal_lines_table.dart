import 'package:drift/drift.dart';

class JournalLines extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get journalId => integer()();

  IntColumn get accountId => integer()();

  RealColumn get debit => real().withDefault(const Constant(0))();

  RealColumn get credit => real().withDefault(const Constant(0))();

  TextColumn get description => text()();
}
