import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {}

class LoadNextEvent extends EventsEvent {}

class CreateEvent extends EventsEvent {
  final EventEntity event;
  const CreateEvent(this.event);
  @override
  List<Object?> get props => [event];
}

class UpdateEvent extends EventsEvent {
  final EventEntity event;
  const UpdateEvent(this.event);
  @override
  List<Object?> get props => [event];
}

class DeleteEvent extends EventsEvent {
  final String eventId;
  const DeleteEvent(this.eventId);
  @override
  List<Object?> get props => [eventId];
}
