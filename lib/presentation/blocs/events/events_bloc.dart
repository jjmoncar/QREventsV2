import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository _eventRepository;

  EventsBloc(this._eventRepository) : super(EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadNextEvent>(_onLoadNextEvent);
    on<CreateEvent>(_onCreateEvent);
    on<UpdateEvent>(_onUpdateEvent);
    on<DeleteEvent>(_onDeleteEvent);
  }

  Future<void> _onLoadEvents(
      LoadEvents event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    final result = await _eventRepository.getEvents();
    final nextResult = await _eventRepository.getNextEvent();

    result.fold(
      (error) => emit(EventsError(error)),
      (events) {
        final nextEvent = nextResult.fold((_) => null, (e) => e);
        emit(EventsLoaded(events: events, nextEvent: nextEvent));
      },
    );
  }

  Future<void> _onLoadNextEvent(
      LoadNextEvent event, Emitter<EventsState> emit) async {
    final currentState = state;
    final nextResult = await _eventRepository.getNextEvent();
    final nextEvent = nextResult.fold((_) => null, (e) => e);

    if (currentState is EventsLoaded) {
      emit(EventsLoaded(events: currentState.events, nextEvent: nextEvent));
    }
  }

  Future<void> _onCreateEvent(
      CreateEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    final result = await _eventRepository.createEvent(event.event);
    result.fold(
      (error) => emit(EventsError(error)),
      (created) {
        emit(EventCreated(created));
        add(LoadEvents());
      },
    );
  }

  Future<void> _onUpdateEvent(
      UpdateEvent event, Emitter<EventsState> emit) async {
    final currentState = state;
    EventEntity? oldEvent;
    if (currentState is EventsLoaded) {
      try {
        oldEvent = currentState.events.firstWhere((e) => e.id == event.event.id);
      } catch (_) {
        // Not found in current list
      }
    }

    emit(EventsLoading());
    final result = await _eventRepository.updateEvent(event.event);
    result.fold(
      (error) => emit(EventsError(error)),
      (updatedEvent) async {
        // Notification Trigger Logic
        if (oldEvent != null) {
          final isCancelled = updatedEvent.status == 'cancelled' && oldEvent.status != 'cancelled';
          final hasStructuralChanges = updatedEvent.dateTime != oldEvent.dateTime ||
                                       updatedEvent.location != oldEvent.location;

          if (isCancelled) {
            await _eventRepository.triggerNotifications(updatedEvent.id, 'cancel');
          } else if (hasStructuralChanges) {
            await _eventRepository.triggerNotifications(updatedEvent.id, 'update');
          }
        }

        emit(EventUpdated(updatedEvent));
        add(LoadEvents());
      },
    );
  }

  Future<void> _onDeleteEvent(
      DeleteEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    final result = await _eventRepository.deleteEvent(event.eventId);
    result.fold(
      (error) => emit(EventsError(error)),
      (_) {
        emit(EventDeleted());
        add(LoadEvents());
      },
    );
  }
}
