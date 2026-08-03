import 'dart:async';

import 'app_event.dart';

class EventBus {
  final StreamController<AppEvent> _controller =
      StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  void publish(AppEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
