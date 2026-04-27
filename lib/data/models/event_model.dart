import '../../domain/entities/event.dart';

class EventModel extends EventEntity {
  const EventModel({
    required super.id,
    required super.ownerId,
    required super.title,
    super.type,
    required super.dateTime,
    super.location,
    super.description,
    super.maxGuests,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.totalInvited,
    super.totalConfirmed,
    super.totalPending,
    super.totalWithQr,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Handle aggregated guest counts if present
    int? totalInvited;
    int? totalConfirmed;
    int? totalPending;
    int? totalWithQr;

    if (json['guests'] is List) {
      final guests = json['guests'] as List;
      totalInvited = 0;
      totalConfirmed = 0;
      totalPending = 0;
      totalWithQr = 0;
      for (final g in guests) {
        final total = (g['total_guests'] as int?) ?? 1;
        totalInvited = totalInvited! + total;
        if (g['status'] == 'checked_in' ||
            g['attendance_status'] == 'confirmed') {
          totalConfirmed = totalConfirmed! + (g['guests_checked_in'] as int? ?? 0);
        }
        if (g['qr_code_token'] != null) {
          totalWithQr = totalWithQr! + 1;
        }
      }
      totalPending = totalInvited! - totalConfirmed!;
    }

    return EventModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      title: json['name'] as String,
      type: json['type'] as String? ?? 'otro',
      dateTime: DateTime.parse(json['date'] as String),
      location: json['location'] as String?,
      description: json['description'] as String?,
      maxGuests: json['max_guests'] as int? ?? 100,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      totalInvited: totalInvited,
      totalConfirmed: totalConfirmed,
      totalPending: totalPending,
      totalWithQr: totalWithQr,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'owner_id': ownerId,
      'name': title,
      'type': type,
      'date': dateTime.toIso8601String(),
      'location': location,
      'description': description,
      'max_guests': maxGuests,
      'status': status,
    };
  }
}
