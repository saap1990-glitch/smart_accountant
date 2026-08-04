import 'package:flutter_test/flutter_test.dart';
import 'package:smart_accountant/core/accounting/domain/value_objects/currency.dart';
import 'package:smart_accountant/core/accounting/domain/value_objects/exchange_rate.dart';
import 'package:smart_accountant/core/accounting/domain/value_objects/money.dart';

void main() {
  test('Exchange rate converts money correctly', () {
    const usd = Currency(code: 'USD', name: 'US Dollar');
    const yer = Currency(code: 'YER', name: 'Yemeni Rial');

    const rate = ExchangeRate(from: usd, to: yer, rate: 530);

    expect(rate.convert(const Money(10)), const Money(5300));
  });
}
