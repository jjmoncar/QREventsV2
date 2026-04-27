import 'package:equatable/equatable.dart';
import '../../../domain/entities/guest.dart';
import '../../../domain/entities/event.dart';

abstract class GuestsState extends Equatable {
  const GuestsState();
  @override
  List<Object?> get props => [];
}

class GuestsInitial extends GuestsState {}

class GuestsLoading extends GuestsState {}

class GuestsLoaded extends GuestsState {
  final List<GuestEntity> guests;
  final String eventId;
  final EventEntity? event;

  const GuestsLoaded({
    required this.guests,
    required this.eventId,
    this.event,
  });

  int get totalInvited =>
      guests.fold(0, (sum, g) => sum + g.totalGuests);
  int get totalCheckedIn =>
      guests.fold(0, (sum, g) => sum + g.guestsCheckedIn);
  int get totalPending => totalInvited - totalCheckedIn;

  @override
  List<Object?> get props => [guests, eventId, event];
}

class GuestAdded extends GuestsState {
  final GuestEntity guest;
  const GuestAdded(this.guest);
  @override
  List<Object?> get props => [guest];
}

class GuestsError extends GuestsState {
  final String message;
  const GuestsError(this.message);
  @override
  List<Object?> get props => [message];
}
