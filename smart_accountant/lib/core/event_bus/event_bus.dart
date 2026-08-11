import 'dart:async';
import 'package:get_it/get_it.dart';

class AppEventBus {
  final _controllers = <Type, StreamController<dynamic>>{};

  void fire<T>(T event) {
    final controller = _controllers[T] as StreamController<T>?;
    if (controller != null && !controller.isClosed) {
      controller.add(event);
    }
  }

  Stream<T> on<T>() {
    final controller =
        _controllers.putIfAbsent(T, () => StreamController<T>.broadcast());
    return controller.stream as Stream<T>;
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}

extension EventBusLocator on GetIt {
  AppEventBus get eventBus => this<AppEventBus>();
}
