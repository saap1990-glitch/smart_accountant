import 'package:drift/drift.dart';

class Companies extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get nameArabic => text()();

  TextColumn get nameEnglish => text().nullable()();

  TextColumn get phone => text().nullable()();

  TextColumn get address => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
