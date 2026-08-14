import 'dart:async';

class EventBus {
  final StreamController<Object> _controller =
      StreamController<Object>.broadcast();

  Stream<T> on<T>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  void publish(Object event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
