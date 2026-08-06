import '../../database/app_database.dart';

class WarehouseService {
  final AppDatabase db;

  WarehouseService(this.db);

  Future<int> createWarehouse({
    required String code,
    required String name,
  }) {

    return db.into(db.warehouses).insert(
      WarehousesCompanion.insert(
        code: code,
        name: name,
      ),
    );
  }
}
