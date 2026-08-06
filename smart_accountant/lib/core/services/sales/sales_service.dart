import '../accounting/document_service.dart';
import '../inventory/inventory_operation_service.dart';

class SalesService {

  final DocumentService documents;
  final InventoryOperationService inventory;

  SalesService(
    this.documents,
    this.inventory,
  );


  Future<int> createSale({
    required int customerAccountId,
    required int revenueAccountId,
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double price,
    required String currency,
  }) async {

    await inventory.stockOut(
      itemId: itemId,
      warehouseId: warehouseId,
      quantity: quantity,
      cost: price,
    );

    return documents.createAutoSale(
      accountId: customerAccountId,
      currency: currency,
      amount: quantity * price,
    );
  }
}
