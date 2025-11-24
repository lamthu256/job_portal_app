import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class JobUpdatedEvent {
  final int jobId;
  JobUpdatedEvent(this.jobId);
}

class ApplicationUpdatedEvent {
  final int jobId;
  ApplicationUpdatedEvent(this.jobId);
}
