import 'package:equatable/equatable.dart';
import '../../../domain/entities/guest.dart';

abstract class GuestsEvent extends Equatable {
  const GuestsEvent();
  @override
  List<Object?> get props => [];
}

class LoadGuests extends GuestsEvent {
  final String eventId;
  const LoadGuests(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class AddGuest extends GuestsEvent {
  final GuestEntity guest;
  const AddGuest(this.guest);
  @override
  List<Object?> get props => [guest];
}

class UpdateGuest extends GuestsEvent {
  final GuestEntity guest;
  const UpdateGuest(this.guest);
  @override
  List<Object?> get props => [guest];
}

class DeleteGuest extends GuestsEvent {
  final String guestId;
  final String eventId;
  const DeleteGuest({required this.guestId, required this.eventId});
  @override
  List<Object?> get props => [guestId, eventId];
}

class SearchGuests extends GuestsEvent {
  final String eventId;
  final String query;
  const SearchGuests({required this.eventId, required this.query});
  @override
  List<Object?> get props => [eventId, query];
}

class SendInvitation extends GuestsEvent {
  final GuestEntity guest;
  final String channel; // 'email', 'whatsapp', 'telegram'
  const SendInvitation({required this.guest, required this.channel});
  @override
  List<Object?> get props => [guest, channel];
}
