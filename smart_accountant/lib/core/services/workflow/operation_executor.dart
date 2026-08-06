import 'workflow_manager.dart';

class OperationExecutor {

  final WorkflowManager workflow;

  OperationExecutor(this.workflow);


  Future<T> run<T>({
    required String operation,
    required Future<T> Function() execute,
  }) {

    return workflow.execute<T>(
      operation: operation,
      action: execute,
    );
  }
}
