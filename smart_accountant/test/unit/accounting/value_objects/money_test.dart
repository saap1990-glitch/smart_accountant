import 'package:flutter_test/flutter_test.dart';
import 'package:smart_accountant/core/accounting/domain/value_objects/money.dart';

void main() {
  test('Money addition', () {
    expect(const Money(100) + const Money(50), const Money(150));
  });

  test('Money subtraction', () {
    expect(const Money(100) - const Money(40), const Money(60));
  });

  test('Money zero', () {
    expect(const Money(0).isZero, true);
  });
}
