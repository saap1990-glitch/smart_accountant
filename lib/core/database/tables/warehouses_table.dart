import 'package:drift/drift.dart';

class Warehouses extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().withLength(min: 1, max: 30)();

  TextColumn get name => text().withLength(min: 1, max: 150)();

  TextColumn get location => text().nullable()();

  TextColumn get address => text().nullable()();

  TextColumn get notes => text().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
