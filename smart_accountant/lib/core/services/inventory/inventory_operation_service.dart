import 'inventory_service.dart';

class InventoryOperationService {

  final InventoryService inventory;

  InventoryOperationService(this.inventory);


  Future<int> stockIn({
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double cost,
  }) {

    return inventory.addTransaction(
      itemId: itemId,
      warehouseId: warehouseId,
      quantity: quantity,
      cost: cost,
      type: 'STOCK_IN',
    );
  }


  Future<int> stockOut({
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double cost,
  }) {

    return inventory.addTransaction(
      itemId: itemId,
      warehouseId: warehouseId,
      quantity: -quantity,
      cost: cost,
      type: 'STOCK_OUT',
    );
  }


  Future<int> transfer({
    required int itemId,
    required int fromWarehouse,
    required int toWarehouse,
    required double quantity,
    required double cost,
  }) async {

    await stockOut(
      itemId: itemId,
      warehouseId: fromWarehouse,
      quantity: quantity,
      cost: cost,
    );

    return stockIn(
      itemId: itemId,
      warehouseId: toWarehouse,
      quantity: quantity,
      cost: cost,
    );
  }
}
