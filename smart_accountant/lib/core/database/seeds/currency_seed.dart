import 'package:drift/drift.dart';

import '../app_database.dart';

class CurrencySeed {
  final AppDatabase db;

  CurrencySeed(this.db);

  Future<void> seed() async {
    final currencies = await db.select(db.currencies).get();

    if (currencies.isNotEmpty) {
      return;
    }

    final yerId = await db
        .into(db.currencies)
        .insert(
          CurrenciesCompanion.insert(
            code: 'YER',
            nameArabic: 'الريال اليمني',
            nameEnglish: const Value('Yemeni Rial'),
            isBase: const Value(true),
          ),
        );

    final usdId = await db
        .into(db.currencies)
        .insert(
          CurrenciesCompanion.insert(
            code: 'USD',
            nameArabic: 'الدولار الأمريكي',
            nameEnglish: const Value('US Dollar'),
          ),
        );

    final sarId = await db
        .into(db.currencies)
        .insert(
          CurrenciesCompanion.insert(
            code: 'SAR',
            nameArabic: 'الريال السعودي',
            nameEnglish: const Value('Saudi Riyal'),
          ),
        );

    await db.batch((batch) {
      batch.insertAll(db.exchangeRates, [
        ExchangeRatesCompanion.insert(
          currencyId: yerId,
          rate: 1,
          date: DateTime.now(),
        ),

        ExchangeRatesCompanion.insert(
          currencyId: usdId,
          rate: 530,
          date: DateTime.now(),
        ),

        ExchangeRatesCompanion.insert(
          currencyId: sarId,
          rate: 140,
          date: DateTime.now(),
        ),
      ]);
    });
  }
}
