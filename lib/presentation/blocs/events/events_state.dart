import 'package:equatable/equatable.dart';
import '../../../domain/entities/event.dart';

abstract class EventsState extends Equatable {
  const EventsState();
  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventEntity> events;
  final EventEntity? nextEvent;
  const EventsLoaded({required this.events, this.nextEvent});
  @override
  List<Object?> get props => [events, nextEvent];
}

class EventCreated extends EventsState {
  final EventEntity event;
  const EventCreated(this.event);
  @override
  List<Object?> get props => [event];
}

class EventUpdated extends EventsState {
  final EventEntity event;
  const EventUpdated(this.event);
  @override
  List<Object?> get props => [event];
}

class EventDeleted extends EventsState {}

class EventsError extends EventsState {
  final String message;
  const EventsError(this.message);
  @override
  List<Object?> get props => [message];
}
