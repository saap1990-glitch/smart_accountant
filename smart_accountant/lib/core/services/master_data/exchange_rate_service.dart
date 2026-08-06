import '../../database/app_database.dart';

class ExchangeRateService {
  final AppDatabase db;

  ExchangeRateService(this.db);

  Future<int> createRate({
    required int currencyId,
    required double rate,
  }) {

    return db.into(db.exchangeRates).insert(
      ExchangeRatesCompanion.insert(
        currencyId: currencyId,
        rate: rate,
        date: DateTime.now(),
      ),
    );
  }
}
