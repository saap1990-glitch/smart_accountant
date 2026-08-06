import '../../database/app_database.dart';

class UnitService {
  final AppDatabase db;

  UnitService(this.db);

  Future<int> createUnit({
    required String name,
    required String symbol,
  }) {

    return db.into(db.units).insert(
      UnitsCompanion.insert(
        name: name,
        symbol: symbol,
      ),
    );
  }
}
