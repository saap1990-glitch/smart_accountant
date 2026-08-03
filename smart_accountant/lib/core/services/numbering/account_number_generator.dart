import '../../database/app_database.dart';

class AccountNumberGenerator {
  final AppDatabase db;

  AccountNumberGenerator(this.db);

  Future<String> generate(String parentNumber) async {
    final accounts = await db.select(db.accounts).get();

    final children = accounts
        .where((a) => a.accountNumber.startsWith(parentNumber))
        .toList();

    var next = children.length + 1;

    return '$parentNumber'
        '${next.toString().padLeft(2, '0')}';
  }
}
