class Money {
  final double value;

  const Money(this.value);

  Money operator +(Money other) => Money(value + other.value);

  Money operator -(Money other) => Money(value - other.value);

  Money operator *(double factor) => Money(value * factor);

  Money operator /(double divisor) => Money(value / divisor);

  bool operator >(Money other) => value > other.value;

  bool operator <(Money other) => value < other.value;

  bool operator >=(Money other) => value >= other.value;

  bool operator <=(Money other) => value <= other.value;

  bool get isZero => value == 0;

  @override
  bool operator ==(Object other) => other is Money && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toStringAsFixed(2);
}
