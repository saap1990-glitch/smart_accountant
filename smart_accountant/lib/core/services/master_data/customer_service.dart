import '../../database/app_database.dart';
import 'package:drift/drift.dart';

class CustomerService {
  final AppDatabase db;

  CustomerService(this.db);

  Future<int> createCustomer({
    required String code,
    required String name,
    required String phone,
    required int accountId,
  }) async {

    return await db.into(db.customers).insert(
      CustomersCompanion.insert(
        code: code,
        name: name,
        phone: Value(phone),
        accountId: accountId,
      ),
    );
  }
}
