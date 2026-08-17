import 'package:drift/drift.dart';

class Items extends Table {
  IntColumn get id => integer().autoIncrement()();

  // الهوية
  TextColumn get code =>
      text().unique()();

  TextColumn get name =>
      text()();

  TextColumn get nameEn =>
      text().nullable()();

  // التصنيف
  TextColumn get itemType =>
      text().withDefault(const Constant('inventory'))();

  TextColumn get category =>
      text().nullable()();

  // الوحدة
  TextColumn get unit =>
      text()();

  // الأسعار
  RealColumn get cost =>
      real().withDefault(const Constant(0))();

  RealColumn get price =>
      real().withDefault(const Constant(0))();

  // المخزون
  RealColumn get openingQuantity =>
      real().withDefault(const Constant(0))();

  RealColumn get minimumQuantity =>
      real().withDefault(const Constant(0))();

  RealColumn get maximumQuantity =>
      real().withDefault(const Constant(0))();

  // بيانات إضافية
  TextColumn get barcode =>
      text().nullable()();

  TextColumn get sku =>
      text().nullable()();

  TextColumn get description =>
      text().nullable()();

  TextColumn get notes =>
      text().nullable()();

  // الحالة
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isService =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
