import '../accounting/transaction_result.dart';

enum WorkflowAction {
  saveAsDraft,
  approve,
  post,
  cancel,
}

class WorkflowEngine {
  TransactionStatus execute(TransactionStatus current, WorkflowAction action) {
    switch (current) {
      case TransactionStatus.draft:
        if (action == WorkflowAction.approve) return TransactionStatus.approved;
        if (action == WorkflowAction.cancel) return TransactionStatus.cancelled;
        break;
      case TransactionStatus.approved:
        if (action == WorkflowAction.post) return TransactionStatus.posted;
        if (action == WorkflowAction.cancel) return TransactionStatus.cancelled;
        break;
      case TransactionStatus.posted:
        // لا يمكن تغيير الحالة بعد الترحيل (إلا بإلغاء خاص)
        break;
      case TransactionStatus.cancelled:
        // لا يمكن تغيير الحالة بعد الإلغاء
        break;
    }
    return current; // لا تغيير إذا كان الإجراء غير مسموح
  }
}
