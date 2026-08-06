import '../../database/app_database.dart';
import 'package:drift/drift.dart';

class ExchangeCompanyService {
  final AppDatabase db;

  ExchangeCompanyService(this.db);

  Future<int> createExchangeCompany({
    required String code,
    required String nameArabic,
    required int currencyId,
    required int accountId,
    String? notes,
  }) {

    return db.into(db.exchangeCompanies).insert(
      ExchangeCompaniesCompanion.insert(
        code: code,
        nameArabic: nameArabic,
        currencyId: currencyId,
        accountId: accountId,
        notes: Value(notes),
      ),
    );
  }
}
