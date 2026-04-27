import '../../domain/entities/guest.dart';

class GuestModel extends GuestEntity {
  const GuestModel({
    required super.id,
    required super.eventId,
    required super.name,
    super.email,
    super.whatsapp,
    super.telegram,
    super.phone,
    super.totalGuests,
    super.guestsCheckedIn,
    super.qrCodeToken,
    super.checkInTime,
    super.status,
    super.attendanceStatus,
    super.invitationChannel,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      name: json['full_name'] as String,
      email: json['email'] as String?,
      whatsapp: json['whatsapp'] as String?,
      telegram: json['telegram'] as String?,
      phone: json['phone'] as String?,
      totalGuests: json['total_guests'] as int? ?? 1,
      guestsCheckedIn: json['guests_checked_in'] as int? ?? 0,
      qrCodeToken: json['qr_code_token'] as String?,
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
      attendanceStatus: json['attendance_status'] as String? ?? 'pending',
      invitationChannel: json['invitation_channel'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'full_name': name,
      'email': email,
      'whatsapp': whatsapp,
      'telegram': telegram,
      'phone': phone,
      'total_guests': totalGuests,
      'invitation_channel': invitationChannel,
      'notes': notes,
    };
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'event_id': eventId,
      'full_name': name,
      'total_guests': totalGuests,
      'guests_checked_in': guestsCheckedIn,
      'qr_code_token': qrCodeToken,
      'status': status,
    };
  }
}
