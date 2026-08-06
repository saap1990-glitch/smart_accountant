import '../../database/app_database.dart';
import 'package:drift/drift.dart';

class SupplierService {
  final AppDatabase db;

  SupplierService(this.db);

  Future<int> createSupplier({
    required String code,
    required String name,
    required String phone,
    required int accountId,
  }) async {

    return await db.into(db.suppliers).insert(
      SuppliersCompanion.insert(
        code: code,
        name: name,
        phone: Value(phone),
        accountId: accountId,
      ),
    );
  }
}
