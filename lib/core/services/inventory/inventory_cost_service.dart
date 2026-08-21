import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class InventoryCostResult {

  const InventoryCostResult({
    required this.quantity,
    required this.averageCost,
    required this.stockValue,
    required this.costOfGoodsSold,
  });
  final double quantity;
  final double averageCost;
  final double stockValue;
  final double costOfGoodsSold;
}

class InventoryCostService {

  InventoryCostService(this._db);
  final AppDatabase _db;

  Future<InventoryCostResult> calculateItemCost(int itemId) async {
    final movements =
        await (_db.select(_db.inventoryTransactions)
              ..where((t) => t.itemId.equals(itemId))
              ..orderBy([
                (t) => OrderingTerm.asc(t.date),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();

    double quantity = 0;
    double stockValue = 0;
    double costOfGoodsSold = 0;

    for (final movement in movements) {
      final qty = double.tryParse(movement.quantity) ?? 0;
      final price = double.tryParse(movement.price ?? '0') ?? 0;

      if (qty <= 0) {
        continue;
      }

      switch (_normalizeType(movement.type)) {
        case 'purchase':
        case 'inventory_in':
        case 'return_sale':
          quantity += qty;
          stockValue += qty * price;
          break;

        case 'sale':
        case 'inventory_out':
        case 'return_purchase':
          if (quantity <= 0) {
            throw StateError('لا يمكن إخراج الصنف $itemId لأن رصيده غير كافٍ');
          }

          if (qty > quantity + 0.000001) {
            throw StateError(
              'الكمية المطلوبة للصنف $itemId أكبر من الرصيد المتاح',
            );
          }

          final averageCost = stockValue / quantity;
          final movementCost = qty * averageCost;

          quantity -= qty;
          stockValue -= movementCost;
          costOfGoodsSold += movementCost;

          if (quantity.abs() < 0.000001) {
            quantity = 0;
            stockValue = 0;
          }
          break;

        case 'inventory':
          final difference = qty * price;
          quantity += qty;

          if (difference >= 0) {
            stockValue += difference;
          } else {
            final averageCost = quantity > 0 ? stockValue / quantity : 0.0;
            final reduction = (-qty) * averageCost;
            stockValue = (stockValue - reduction).clamp(0, double.infinity);
          }
          break;

        default:
          break;
      }

      if (stockValue < 0 && stockValue.abs() < 0.000001) {
        stockValue = 0;
      }
    }

    final averageCost = quantity > 0 ? stockValue / quantity : 0.0;

    return InventoryCostResult(
      quantity: quantity,
      averageCost: averageCost.toDouble(),
      stockValue: stockValue.toDouble(),
      costOfGoodsSold: costOfGoodsSold.toDouble(),
    );
  }

  Future<InventoryCostResult> calculateItemCostAt(
    int itemId,
    DateTime date,
  ) async {
    final movements =
        await (_db.select(_db.inventoryTransactions)
              ..where(
                (t) =>
                    t.itemId.equals(itemId) &
                    t.date.isSmallerOrEqualValue(date),
              )
              ..orderBy([
                (t) => OrderingTerm.asc(t.date),
                (t) => OrderingTerm.asc(t.id),
              ]))
            .get();

    double quantity = 0;
    double stockValue = 0;
    double costOfGoodsSold = 0;

    for (final movement in movements) {
      final qty = double.tryParse(movement.quantity) ?? 0;
      final price = double.tryParse(movement.price ?? '0') ?? 0;

      if (qty <= 0) {
        continue;
      }

      switch (_normalizeType(movement.type)) {
        case 'purchase':
        case 'inventory_in':
        case 'return_sale':
          quantity += qty;
          stockValue += qty * price;
          break;

        case 'sale':
        case 'inventory_out':
        case 'return_purchase':
          if (quantity <= 0 || qty > quantity + 0.000001) {
            throw StateError('رصيد المخزون غير كافٍ للصنف $itemId');
          }

          final averageCost = stockValue / quantity;
          final movementCost = qty * averageCost;

          quantity -= qty;
          stockValue -= movementCost;
          costOfGoodsSold += movementCost;

          if (quantity.abs() < 0.000001) {
            quantity = 0;
            stockValue = 0;
          }
          break;

        case 'inventory':
          quantity += qty;
          stockValue += qty * price;
          break;

        default:
          break;
      }
    }

    final averageCost = quantity > 0 ? stockValue / quantity : 0.0;

    return InventoryCostResult(
      quantity: quantity,
      averageCost: averageCost.toDouble(),
      stockValue: stockValue.toDouble(),
      costOfGoodsSold: costOfGoodsSold.toDouble(),
    );
  }

  String _normalizeType(String value) {
    switch (value.toLowerCase().trim()) {
      case 'purchase':
      case 'purchases':
        return 'purchase';

      case 'sale':
      case 'sales':
        return 'sale';

      case 'sale_return':
      case 'sales_return':
      case 'return_sale':
        return 'return_sale';

      case 'purchase_return':
      case 'purchases_return':
      case 'return_purchase':
        return 'return_purchase';

      case 'inventory_in':
      case 'stock_in':
        return 'inventory_in';

      case 'inventory_out':
      case 'stock_out':
        return 'inventory_out';

      case 'inventory':
      case 'adjustment':
        return 'inventory';

      default:
        return value.toLowerCase().trim();
    }
  }
}
