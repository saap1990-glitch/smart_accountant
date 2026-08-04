import 'package:drift/drift.dart';

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get symbol => text()();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
