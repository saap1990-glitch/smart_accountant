import 'package:drift/drift.dart';

class Warehouses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get name => text()();

  TextColumn get location => text().nullable()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
