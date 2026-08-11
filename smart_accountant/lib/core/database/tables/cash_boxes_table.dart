import 'package:drift/drift.dart';

class CashBoxes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
