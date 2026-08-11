import 'package:drift/drift.dart';

class AccountRules extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get ruleCode => text().unique()();

  TextColumn get descriptionAr => text()();

  TextColumn get descriptionEn => text().nullable()();

  TextColumn get ruleValue => text().nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
}
