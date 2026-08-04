import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get code => text().unique()();

  TextColumn get name => text()();

  IntColumn get categoryId => integer()();

  IntColumn get unitId => integer()();

  TextColumn get barcode => text().nullable()();

  RealColumn get cost => real().withDefault(const Constant(0))();

  RealColumn get salePrice => real().withDefault(const Constant(0))();

  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
