import 'package:drift/drift.dart';

class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get name => text()();

  TextColumn get phone => text().nullable()();

  TextColumn get address => text().nullable()();

  IntColumn get accountId => integer()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
