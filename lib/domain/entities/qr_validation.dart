import 'package:equatable/equatable.dart';

enum QrValidationType { full, partial, invalid, used, exceeded, cancelled }

class QrValidationResult extends Equatable {
  final String status; // 'success' or 'error'
  final String message;
  final QrValidationType type;
  final int? remaining;
  final String? guestName;
  final int? checkedIn;
  final int? total;
  final String? eventName;

  const QrValidationResult({
    required this.status,
    required this.message,
    required this.type,
    this.remaining,
    this.guestName,
    this.checkedIn,
    this.total,
    this.eventName,
  });

  bool get isSuccess => status == 'success';
  bool get isPartial => type == QrValidationType.partial;

  factory QrValidationResult.fromJson(Map<String, dynamic> json) {
    return QrValidationResult(
      status: json['status'] as String,
      message: json['message'] as String,
      type: _parseType(json['type'] as String),
      remaining: json['remaining'] as int?,
      guestName: json['guest_name'] as String?,
      checkedIn: json['checked_in'] as int?,
      total: json['total'] as int?,
      eventName: json['event_name'] as String?,
    );
  }

  static QrValidationType _parseType(String type) {
    switch (type) {
      case 'full':
        return QrValidationType.full;
      case 'partial':
        return QrValidationType.partial;
      case 'used':
        return QrValidationType.used;
      case 'exceeded':
        return QrValidationType.exceeded;
      case 'cancelled':
        return QrValidationType.cancelled;
      default:
        return QrValidationType.invalid;
    }
  }

  @override
  List<Object?> get props =>
      [status, message, type, remaining, guestName, checkedIn, total];
}
