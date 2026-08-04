class Currency {
  final String code;
  final String name;
  final int decimalPlaces;

  const Currency({
    required this.code,
    required this.name,
    this.decimalPlaces = 2,
  });

  @override
  bool operator ==(Object other) =>
      other is Currency &&
      other.code == code &&
      other.decimalPlaces == decimalPlaces;

  @override
  int get hashCode => Object.hash(code, decimalPlaces);
}
