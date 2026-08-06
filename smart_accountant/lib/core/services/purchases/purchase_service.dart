import '../accounting/document_service.dart';
import '../inventory/inventory_operation_service.dart';

class PurchaseService {

  final DocumentService documents;
  final InventoryOperationService inventory;

  PurchaseService(
    this.documents,
    this.inventory,
  );


  Future<int> createPurchase({
    required int supplierAccountId,
    required int inventoryAccountId,
    required int itemId,
    required int warehouseId,
    required double quantity,
    required double cost,
    required String currency,
  }) async {

    await inventory.stockIn(
      itemId: itemId,
      warehouseId: warehouseId,
      quantity: quantity,
      cost: cost,
    );


    return documents.createAutoPurchase(
      accountId: supplierAccountId,
      currency: currency,
      amount: quantity * cost,
    );
  }
}
