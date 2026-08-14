import 'package:drift/drift.dart';

class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get exchangeRate => text().withDefault(const Constant('1.0'))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}
