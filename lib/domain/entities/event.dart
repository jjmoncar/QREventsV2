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
    if (diff.isNegative) {
      if (diff.abs().inHours < 6) return 'En curso';
      return 'Evento finalizado';
    }
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    if (days > 0) return '$days días, $hours hrs';
    if (hours > 0) return '$hours hrs, $minutes min';
    return '$minutes min';
  }

  bool get isPreviousDay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDay = DateTime(dateTime.year, dateTime.month, dateTime.day);
    return today.isBefore(eventDay);
  }

  bool get isTooEarly {
    if (isPreviousDay) return true;
    final now = DateTime.now();
    final startWindow = dateTime.subtract(const Duration(hours: 1));
    return now.isBefore(startWindow);
  }

  bool get isTooLate {
    final now = DateTime.now();
    final endWindow = dateTime.add(const Duration(hours: 6));
    return now.isAfter(endWindow) || status == 'completed';
  }

  bool get isScanningAllowed {
    // Condition 1: Same day
    final now = DateTime.now();
    final isSameDay = now.year == dateTime.year && 
                     now.month == dateTime.month && 
                     now.day == dateTime.day;
    
    // Condition 2: Within 1h before and 6h after
    if (!isSameDay) return false;
    
    return !isTooEarly && !isTooLate && status != 'cancelled';
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
