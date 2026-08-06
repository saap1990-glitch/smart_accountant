import '../../database/app_database.dart';

class InventoryService {

  final AppDatabase db;

  InventoryService(this.db);


  Future<int> addTransaction({
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double cost,
    required String type,
  }) {

    return db.into(db.inventoryTransactions).insert(
      InventoryTransactionsCompanion.insert(
        itemId: itemId,
        warehouseId: warehouseId,
        quantity: quantity,
        cost: cost,
        type: type,
      ),
    );
  }
}
