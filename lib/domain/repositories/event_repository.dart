import 'package:dartz/dartz.dart';
import '../entities/event.dart';

abstract class EventRepository {
  Future<Either<String, List<EventEntity>>> getEvents();
  Future<Either<String, EventEntity>> getEvent(String id);
  Future<Either<String, EventEntity>> createEvent(EventEntity event);
  Future<Either<String, EventEntity>> updateEvent(EventEntity event);
  Future<Either<String, void>> deleteEvent(String id);
  Future<Either<String, EventEntity>> getNextEvent();
  Future<Either<String, void>> triggerNotifications(String eventId, String changeType);
}
