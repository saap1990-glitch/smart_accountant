import 'package:drift/drift.dart';

class ExchangeRates extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get currencyId => integer()();

  RealColumn get rate => real()();

  DateTimeColumn get date => dateTime()();
}
