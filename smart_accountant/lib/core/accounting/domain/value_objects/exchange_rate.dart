import 'currency.dart';
import 'money.dart';

class ExchangeRate {
  final Currency from;
  final Currency to;
  final double rate;

  const ExchangeRate({
    required this.from,
    required this.to,
    required this.rate,
  });

  Money convert(Money amount) {
    return Money(amount.value * rate);
  }

  @override
  bool operator ==(Object other) =>
      other is ExchangeRate &&
      other.from == from &&
      other.to == to &&
      other.rate == rate;

  @override
  int get hashCode => Object.hash(from, to, rate);
}
