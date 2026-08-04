import 'package:flutter_test/flutter_test.dart';
import 'package:smart_accountant/core/accounting/domain/value_objects/currency.dart';

void main() {
  test('Currency equality', () {
    expect(
      const Currency(code: 'YER', name: 'Yemeni Rial'),
      const Currency(code: 'YER', name: 'Yemeni Rial'),
    );
  });

  test('Currency code', () {
    expect(const Currency(code: 'USD', name: 'US Dollar').code, 'USD');
  });
}
