import 'package:drift/drift.dart';

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get number => text().unique()();

  TextColumn get type => text()();

  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();

  IntColumn get accountId => integer()();

  TextColumn get currency => text()();

  RealColumn get exchangeRate =>
      real().withDefault(const Constant(1))();

  TextColumn get description => text().nullable()();

  TextColumn get status =>
      text().withDefault(const Constant('draft'))();
}
