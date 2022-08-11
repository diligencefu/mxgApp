import 'package:event_bus/event_bus.dart';

/// The global [EventBus] object.
EventBus eventBus = EventBus();

class UpdateEvent {
  UpdateEvent();
}

class SelectAllEvent {
  bool select;
  SelectAllEvent(this.select);
}

class UpdateTabEvent {
  int tab;
  UpdateTabEvent(this.tab);
}

class UpdateDetailEvent {
  UpdateDetailEvent();
}
