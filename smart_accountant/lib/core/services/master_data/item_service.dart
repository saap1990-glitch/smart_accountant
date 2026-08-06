import '../../database/app_database.dart';
import 'package:drift/drift.dart';

class ItemService {
  final AppDatabase db;

  ItemService(this.db);

  Future<int> createItem({
    required String code,
    required String name,
    required int categoryId,
    required int unitId,
  }) async {

    return db.into(db.items).insert(
      ItemsCompanion.insert(
        code: code,
        name: name,
        categoryId: categoryId,
        unitId: unitId,
      ),
    );
  }
}
