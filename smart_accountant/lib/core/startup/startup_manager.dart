import '../di/service_locator.dart';

abstract class StartupTask {
  Future<void> execute();
}

class StartupManager {
  final List<StartupTask> tasks;

  StartupManager(this.tasks);

  Future<void> initialize() async {
    for (final task in tasks) {
      await task.execute();
    }
  }
}
