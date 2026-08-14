class SecurityManager {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
  }

  Future<void> dispose() async {
    _initialized = false;
  }
}
