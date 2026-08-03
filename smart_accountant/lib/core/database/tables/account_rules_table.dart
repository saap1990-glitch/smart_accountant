import 'package:drift/drift.dart';

class AccountRules extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get entityType => text()();

  IntColumn get parentAccountId => integer()();

  BoolColumn get autoCreate => boolean().withDefault(const Constant(true))();

  BoolColumn get allowPosting => boolean().withDefault(const Constant(true))();
}
