import '../../database/app_database.dart';

class InventoryReportService {

  final AppDatabase db;

  InventoryReportService(this.db);


  Future<List<Map<String, dynamic>>> stockBalance() async {

    final items = await db.select(db.items).get();
    final transactions =
        await db.select(db.inventoryTransactions).get();


    return items.map((item) {

      double quantity = 0;
      double value = 0;


      final rows = transactions.where(
        (t) => t.itemId == item.id,
      );


      for (final row in rows) {
        quantity += row.quantity;
        value += row.quantity * row.cost;
      }


      return {
        'itemId': item.id,
        'quantity': quantity,
        'value': value,
      };

    }).toList();
  }
}
