class NumberGenerator {
  final Map<String, int> _counters = {};

  Future<String> generate(String type) async {
    final now = DateTime.now();
    final year = now.year;
    final prefix = _getPrefix(type);
    _counters[type] = (_counters[type] ?? 0) + 1;
    final counter = _counters[type].toString().padLeft(6, '0');
    return '$prefix-$year-$counter';
  }

  String _getPrefix(String type) {
    switch (type.toLowerCase()) {
      case 'receipt': return 'RC';
      case 'payment': return 'PV';
      case 'sale': return 'SI';
      case 'purchase': return 'PI';
      case 'journal': return 'JV';
      case 'transfer': return 'TR';
      case 'inventory': return 'INV';
      default: return 'TX';
    }
  }
}
