import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final String id;
  final String ownerId;
  final String title;
  final String type;
  final DateTime dateTime;
  final String? location;
  final String? description;
  final int maxGuests;
  final String status; // 'pending', 'completed', 'cancelled'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Computed fields (from joins)
  final int? totalInvited;
  final int? totalConfirmed;
  final int? totalPending;
  final int? totalWithQr;

  const EventEntity({
    required this.id,
    required this.ownerId,
    required this.title,
    this.type = 'otro',
    required this.dateTime,
    this.location,
    this.description,
    this.maxGuests = 100,
    this.status = 'pending',
    this.createdAt,
    this.updatedAt,
    this.totalInvited,
    this.totalConfirmed,
    this.totalPending,
    this.totalWithQr,
  });

  bool get isActive => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  Duration get timeUntilEvent => dateTime.difference(DateTime.now());

  bool get isPast => DateTime.now().isAfter(dateTime);

  String get countdownText {
    final diff = timeUntilEvent;
    if (diff.isNegative) return 'Evento finalizado';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    if (days > 0) return '$days días, $hours hrs';
    if (hours > 0) return '$hours hrs, $minutes min';
    return '$minutes min';
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        title,
        type,
        dateTime,
        location,
        description,
        maxGuests,
        status,
      ];
}
