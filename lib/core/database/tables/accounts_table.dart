import 'package:drift/drift.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get number => text().unique()();

  TextColumn get nameAr => text()();

  TextColumn get nameEn => text().nullable()();

  IntColumn get parentId =>
      integer().nullable().references(Accounts, #id)();

  IntColumn get level => integer()();

  TextColumn get type => text()();

  TextColumn get nature => text()();

  BoolColumn get acceptsPosting =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isSystem =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  TextColumn get currencyCode =>
      text().withDefault(const Constant('YER'))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
