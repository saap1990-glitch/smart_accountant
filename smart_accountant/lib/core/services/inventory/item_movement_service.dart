import '../../repositories/master_data_repository.dart';

class ItemMovementRecord {
  final String itemId;
  final String itemName;
  final double quantity;
  final double price;
  final String operationType;
  final DateTime date;
  final String? reference;

  const ItemMovementRecord({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.operationType,
    required this.date,
    this.reference,
  });
}

class ItemMovementService {
  final MasterDataRepository _repository;
  final List<ItemMovementRecord> _movements = [];

  ItemMovementService(this._repository);

  void recordMovement({
    required String itemId,
    required String itemName,
    required double quantity,
    required double price,
    required String operationType,
    String? reference,
  }) {
    _movements.add(ItemMovementRecord(
      itemId: itemId,
      itemName: itemName,
      quantity: quantity,
      price: price,
      operationType: operationType,
      date: DateTime.now(),
      reference: reference,
    ));
  }

  List<ItemMovementRecord> getMovementsForItem(String itemId, {DateTime? from, DateTime? to}) {
    return _movements.where((m) {
      if (m.itemId != itemId) return false;
      if (from != null && m.date.isBefore(from)) return false;
      if (to != null && m.date.isAfter(to)) return false;
      return true;
    }).toList();
  }

  Map<String, dynamic> getItemCard(String itemName) {
    final movements = _movements.where((m) => m.itemName == itemName).toList();
    double purchases = 0, sales = 0, returns = 0, adjustments = 0;

    for (var m in movements) {
      if (m.operationType == 'purchase') {
        purchases += m.quantity;
      } else if (m.operationType == 'sale') {
        sales += m.quantity;
      } else if (m.operationType == 'return') {
        returns += m.quantity;
      } else if (m.operationType == 'inventory') {
        adjustments += m.quantity;
      }
    }

    return {
      'item_name': itemName,
      'opening': 0,
      'purchases': purchases,
      'sales': sales,
      'returns': returns,
      'adjustments': adjustments,
      'balance': purchases - sales + returns + adjustments,
      'movements': movements,
    };
  }

  List<Map<String, dynamic>> getAllItemCards() {
    final items = <String>{};
    for (var m in _movements) {
      items.add(m.itemName);
    }
    return items.map((name) => getItemCard(name)).toList();
  }
}
