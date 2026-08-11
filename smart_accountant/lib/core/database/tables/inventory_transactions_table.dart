import 'package:drift/drift.dart';
import 'items_table.dart';

class InventoryTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  TextColumn get type => text()();
  TextColumn get quantity => text()();
  TextColumn get price => text().nullable()();
  TextColumn get reference => text().nullable()();
  DateTimeColumn get date => dateTime()();
}
