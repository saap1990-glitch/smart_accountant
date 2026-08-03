import 'package:drift/drift.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get accountNumber => text().unique()();

  TextColumn get nameArabic => text()();

  TextColumn get nameEnglish => text().nullable()();

  IntColumn get parentId => integer().nullable()();

  IntColumn get level => integer()();

  TextColumn get accountType => text()();

  TextColumn get nature => text()();

  BoolColumn get allowPosting => boolean().withDefault(const Constant(false))();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
