import '../errors/result.dart';
import '../errors/app_exception.dart';
import '../event_bus/event_bus.dart';
import '../audit/audit_entry.dart';
import '../audit/audit_service.dart';
import '../logging/logger.dart';

class TransactionManager {
  final AuditService _audit;
  final AppEventBus _eventBus;

  TransactionManager(this._audit, this._eventBus);

  Future<Result<T>> execute<T>({
    required Future<T> Function() operation,
    required String action,
    required String entityType,
    String? entityId,
    String? description,
  }) async {
    try {
      final result = await operation();
      await _recordAudit(action, entityType, entityId, description, success: true);
      _eventBus.fire(TransactionCompleted(result));
      return Success(result);
    } on AppException catch (e) {
      AppLogger.error('Transaction failed: $e');
      await _recordAudit(action, entityType, entityId, description, success: false);
      return Failure(e);
    } catch (e, stack) {
      AppLogger.error('Unexpected transaction error', error: e, stackTrace: stack);
      await _recordAudit(action, entityType, entityId, description, success: false);
      return Failure(AppException('Unexpected error: $e'));
    }
  }

  Future<void> _recordAudit(String action, String entityType,
      String? entityId, String? description,
      {required bool success}) async {
    final entry = AuditEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      action: success ? action : '$action (FAILED)',
      entityType: entityType,
      entityId: entityId,
      timestamp: DateTime.now(),
      description: description,
    );
    await _audit.record(entry);
  }
}

class TransactionCompleted {
  final dynamic result;
  const TransactionCompleted(this.result);
}
