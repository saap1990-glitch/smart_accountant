import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get nameArabic => text()();

  TextColumn get provider => text()();

  IntColumn get currencyId => integer()();

  IntColumn get accountId => integer()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  TextColumn get notes => text().nullable()();
}
