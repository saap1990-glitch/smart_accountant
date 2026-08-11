import 'package:drift/drift.dart';

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entryNumber => text().unique()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get operationType => text()();
  TextColumn get status => text().withDefault(const Constant('posted'))();
  TextColumn get description => text().nullable()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get currencyCode => text().withDefault(const Constant('YER'))();
  TextColumn get exchangeRate => text().withDefault(const Constant('1'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
