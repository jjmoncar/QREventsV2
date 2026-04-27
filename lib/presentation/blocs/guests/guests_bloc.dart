import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/guest_repository.dart';
import '../../../domain/repositories/event_repository.dart';
import 'guests_event.dart';
import 'guests_state.dart';

class GuestsBloc extends Bloc<GuestsEvent, GuestsState> {
  final GuestRepository _guestRepository;
  final EventRepository _eventRepository;

  GuestsBloc(this._guestRepository, this._eventRepository)
      : super(GuestsInitial()) {
    on<LoadGuests>(_onLoadGuests);
    on<AddGuest>(_onAddGuest);
    on<UpdateGuest>(_onUpdateGuest);
    on<DeleteGuest>(_onDeleteGuest);
    on<SearchGuests>(_onSearchGuests);
    on<SendInvitation>(_onSendInvitation);
  }

  Future<void> _onLoadGuests(
      LoadGuests event, Emitter<GuestsState> emit) async {
    emit(GuestsLoading());
    
    // Fetch guests and event info in parallel or sequence
    final guestsResult = await _guestRepository.getGuests(event.eventId);
    final eventResult = await _eventRepository.getEvent(event.eventId);

    guestsResult.fold(
      (error) => emit(GuestsError(error)),
      (guests) {
        final eventEntity = eventResult.fold((_) => null, (e) => e);
        emit(GuestsLoaded(
          guests: guests,
          eventId: event.eventId,
          event: eventEntity,
        ));
      },
    );
  }

  Future<void> _onAddGuest(AddGuest event, Emitter<GuestsState> emit) async {
    emit(GuestsLoading());
    final result = await _guestRepository.addGuest(event.guest);
    result.fold(
      (error) => emit(GuestsError(error)),
      (guest) {
        emit(GuestAdded(guest));
        add(LoadGuests(event.guest.eventId));
      },
    );
  }

  Future<void> _onUpdateGuest(
      UpdateGuest event, Emitter<GuestsState> emit) async {
    final result = await _guestRepository.updateGuest(event.guest);
    result.fold(
      (error) => emit(GuestsError(error)),
      (_) => add(LoadGuests(event.guest.eventId)),
    );
  }

  Future<void> _onDeleteGuest(
      DeleteGuest event, Emitter<GuestsState> emit) async {
    final result = await _guestRepository.deleteGuest(event.guestId);
    result.fold(
      (error) => emit(GuestsError(error)),
      (_) => add(LoadGuests(event.eventId)),
    );
  }

  Future<void> _onSearchGuests(
      SearchGuests event, Emitter<GuestsState> emit) async {
    if (event.query.isEmpty) {
      add(LoadGuests(event.eventId));
      return;
    }
    final guestsResult =
        await _guestRepository.searchGuests(event.eventId, event.query);
    final eventResult = await _eventRepository.getEvent(event.eventId);

    guestsResult.fold(
      (error) => emit(GuestsError(error)),
      (guests) {
        final eventEntity = eventResult.fold((_) => null, (e) => e);
        emit(GuestsLoaded(
          guests: guests,
          eventId: event.eventId,
          event: eventEntity,
        ));
      },
    );
  }

  Future<void> _onSendInvitation(
      SendInvitation event, Emitter<GuestsState> emit) async {
    final result = await _guestRepository.sendInvitation(event.guest.id, event.channel);
    result.fold(
      (error) => emit(GuestsError(error)),
      (_) => add(LoadGuests(event.guest.eventId)),
    );
  }
}
