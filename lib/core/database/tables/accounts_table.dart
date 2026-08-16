import 'package:drift/drift.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get number => text().unique()();

  TextColumn get nameAr => text()();

  TextColumn get nameEn => text().nullable()();

  IntColumn get parentId => integer().nullable().references(Accounts, #id)();

  IntColumn get level => integer()();

  TextColumn get type => text()();

  TextColumn get nature => text()();

  BoolColumn get acceptsPosting =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  TextColumn get currencyCode => text().withDefault(const Constant('YER'))();

  TextColumn get notes => text().nullable()();

  /// الرصيد الافتتاحي للحساب.
  /// يخزن كنص للحفاظ على دقة القيم المالية مثل بقية النظام.
  TextColumn get openingBalance => text().withDefault(const Constant('0'))();

  /// طبيعة الرصيد الافتتاحي: debit / credit.
  TextColumn get openingBalanceNature =>
      text().withDefault(const Constant('debit'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
