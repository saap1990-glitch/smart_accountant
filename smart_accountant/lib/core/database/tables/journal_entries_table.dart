import 'package:drift/drift.dart';

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get reference => text()();

  TextColumn get description => text()();

  DateTimeColumn get date => dateTime()();

  TextColumn get currency => text()();

  RealColumn get exchangeRate => real().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
