import 'package:drift/drift.dart';

class AccountLinks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get module => text()();

  TextColumn get entityType => text()();

  IntColumn get entityId => integer()();

  IntColumn get accountId => integer()();
}
