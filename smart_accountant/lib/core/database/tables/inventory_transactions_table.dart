import 'package:drift/drift.dart';

class InventoryTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get itemId => integer()();

  IntColumn get warehouseId => integer()();

  TextColumn get type => text()();

  RealColumn get quantity => real()();

  RealColumn get cost => real()();

  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();

  TextColumn get reference => text().nullable()();
}
