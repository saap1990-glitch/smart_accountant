abstract class NumberGenerator {
  Future<String> generate(String type);
}

class DefaultNumberGenerator implements NumberGenerator {
  final Map<String, int> _counters = {};

  @override
  Future<String> generate(String type) async {
    final current = (_counters[type] ?? 0) + 1;

    _counters[type] = current;

    return '$type-${current.toString().padLeft(6, '0')}';
  }
}
