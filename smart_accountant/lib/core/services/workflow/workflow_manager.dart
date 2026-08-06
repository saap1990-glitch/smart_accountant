class WorkflowManager {

  Future<T> execute<T>({
    required String operation,
    required Future<T> Function() action,
  }) async {

    _validate(operation);

    final result = await action();

    return result;
  }


  void _validate(String operation) {
    if (operation.trim().isEmpty) {
      throw Exception('Operation name required');
    }
  }
}
