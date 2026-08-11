import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get cost => text().withDefault(const Constant('0'))();
  TextColumn get price => text().withDefault(const Constant('0'))();
}
