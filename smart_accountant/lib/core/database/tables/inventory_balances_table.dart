import 'package:drift/drift.dart';

class InventoryBalances extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get itemId => integer()();

  IntColumn get warehouseId => integer()();

  RealColumn get quantity => real().withDefault(const Constant(0))();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
