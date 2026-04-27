import 'package:equatable/equatable.dart';

class GuestEntity extends Equatable {
  final String id;
  final String eventId;
  final String name;
  final String? email;
  final String? whatsapp;
  final String? telegram;
  final String? phone;
  final int totalGuests;
  final int guestsCheckedIn;
  final String? qrCodeToken;
  final DateTime? checkInTime;
  final String status; // 'pending' or 'checked_in'
  final String? attendanceStatus; // 'pending', 'confirmed', 'cancelled'
  final String? invitationChannel; // 'email', 'whatsapp', 'telegram'
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GuestEntity({
    required this.id,
    required this.eventId,
    required this.name,
    this.email,
    this.whatsapp,
    this.telegram,
    this.phone,
    this.totalGuests = 1,
    this.guestsCheckedIn = 0,
    this.qrCodeToken,
    this.checkInTime,
    this.status = 'pending',
    this.attendanceStatus = 'pending',
    this.invitationChannel,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  bool get isFullyCheckedIn => guestsCheckedIn >= totalGuests;
  bool get isPartiallyCheckedIn =>
      guestsCheckedIn > 0 && guestsCheckedIn < totalGuests;
  int get remainingGuests => totalGuests - guestsCheckedIn;
  bool get isIndividual => totalGuests == 1;
  bool get isGroup => totalGuests > 1;

  bool get hasWhatsApp => whatsapp != null && whatsapp!.isNotEmpty;
  bool get hasTelegram => telegram != null && telegram!.isNotEmpty;
  bool get hasEmail => email != null && email!.isNotEmpty;
  bool get hasContactMethod => hasWhatsApp || hasTelegram || hasEmail;

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        eventId,
        name,
        email,
        whatsapp,
        telegram,
        phone,
        totalGuests,
        guestsCheckedIn,
        qrCodeToken,
        checkInTime,
        status,
        attendanceStatus,
        invitationChannel,
      ];
}
