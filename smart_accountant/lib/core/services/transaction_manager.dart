abstract class TransactionManager {
  Future<T> run<T>(Future<T> Function() action);
}

class DefaultTransactionManager implements TransactionManager {
  @override
  Future<T> run<T>(Future<T> Function() action) async {
    return await action();
  }
}
