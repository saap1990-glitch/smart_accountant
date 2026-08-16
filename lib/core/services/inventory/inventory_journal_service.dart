import '../../engine/accounting/transaction_context.dart';
import 'inventory_cost_service.dart';

class InventoryJournalService {
  final InventoryCostService _costService;

  InventoryJournalService(this._costService);

  Future<List<JournalItem>> buildSaleLines({
    required List<Map<String, dynamic>> items,
    required int receivableAccountId,
    required int salesAccountId,
    required int inventoryAccountId,
    required int cogsAccountId,
    bool isReturn = false,
  }) async {
    double salesTotal = 0;
    double cogsTotal = 0;

    for (final item in items) {
      final itemId = int.tryParse(item['id']?.toString() ?? '');
      final quantity = (item['quantity'] as num?)?.toDouble() ?? 0;
      final price = (item['price'] as num?)?.toDouble() ?? 0;
      final discount = (item['discount'] as num?)?.toDouble() ?? 0;

      if (itemId == null || quantity <= 0) {
        continue;
      }

      salesTotal += (quantity * price) - discount;

      final cost = await _costService.calculateItemCost(itemId);
      cogsTotal += cost.averageCost * quantity;
    }

    if (salesTotal <= 0) {
      throw StateError('إجمالي البيع يجب أن يكون أكبر من صفر');
    }

    if (cogsTotal < 0) {
      cogsTotal = 0;
    }

    if (!isReturn) {
      return [
        JournalItem(
          accountId: receivableAccountId,
          debit: salesTotal,
          description: 'قيمة المبيعات',
        ),
        JournalItem(
          accountId: salesAccountId,
          credit: salesTotal,
          description: 'إيرادات المبيعات',
        ),
        if (cogsTotal > 0)
          JournalItem(
            accountId: cogsAccountId,
            debit: cogsTotal,
            description: 'تكلفة المبيعات',
          ),
        if (cogsTotal > 0)
          JournalItem(
            accountId: inventoryAccountId,
            credit: cogsTotal,
            description: 'إخراج تكلفة المخزون',
          ),
      ];
    }

    return [
      JournalItem(
        accountId: salesAccountId,
        debit: salesTotal,
        description: 'مرتجع مبيعات',
      ),
      JournalItem(
        accountId: receivableAccountId,
        credit: salesTotal,
        description: 'عكس قيمة المبيعات',
      ),
      if (cogsTotal > 0)
        JournalItem(
          accountId: inventoryAccountId,
          debit: cogsTotal,
          description: 'إعادة تكلفة المخزون',
        ),
      if (cogsTotal > 0)
        JournalItem(
          accountId: cogsAccountId,
          credit: cogsTotal,
          description: 'عكس تكلفة المبيعات',
        ),
    ];
  }

  List<JournalItem> buildPurchaseLines({
    required double total,
    required int inventoryAccountId,
    required int payableAccountId,
    bool isReturn = false,
  }) {
    if (total <= 0) {
      throw StateError('إجمالي الشراء يجب أن يكون أكبر من صفر');
    }

    if (!isReturn) {
      return [
        JournalItem(
          accountId: inventoryAccountId,
          debit: total,
          description: 'إضافة إلى المخزون',
        ),
        JournalItem(
          accountId: payableAccountId,
          credit: total,
          description: 'قيمة المشتريات',
        ),
      ];
    }

    return [
      JournalItem(
        accountId: payableAccountId,
        debit: total,
        description: 'مرتجع مشتريات',
      ),
      JournalItem(
        accountId: inventoryAccountId,
        credit: total,
        description: 'إخراج قيمة المرتجع من المخزون',
      ),
    ];
  }
}
