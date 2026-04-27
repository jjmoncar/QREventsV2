import 'package:dartz/dartz.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/remote/event_remote_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource _remoteDatasource;

  EventRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<String, List<EventEntity>>> getEvents() async {
    try {
      final events = await _remoteDatasource.getEvents();
      return Right(events);
    } catch (e) {
      return Left('Error al obtener eventos: $e');
    }
  }

  @override
  Future<Either<String, EventEntity>> getEvent(String id) async {
    try {
      final event = await _remoteDatasource.getEvent(id);
      return Right(event);
    } catch (e) {
      return Left('Error al obtener evento: $e');
    }
  }

  @override
  Future<Either<String, EventEntity>> createEvent(EventEntity event) async {
    try {
      final model = EventModel(
        id: '',
        ownerId: event.ownerId,
        title: event.title,
        type: event.type,
        dateTime: event.dateTime,
        location: event.location,
        description: event.description,
        maxGuests: event.maxGuests,
      );
      final created = await _remoteDatasource.createEvent(model.toJson());
      return Right(created);
    } catch (e) {
      return Left('Error al crear evento: $e');
    }
  }

  @override
  Future<Either<String, EventEntity>> updateEvent(EventEntity event) async {
    try {
      final model = EventModel(
        id: event.id,
        ownerId: event.ownerId,
        title: event.title,
        type: event.type,
        dateTime: event.dateTime,
        location: event.location,
        description: event.description,
        maxGuests: event.maxGuests,
        status: event.status,
      );
      final updated =
          await _remoteDatasource.updateEvent(event.id, model.toJson());
      return Right(updated);
    } catch (e) {
      return Left('Error al actualizar evento: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteEvent(String id) async {
    try {
      await _remoteDatasource.deleteEvent(id);
      return const Right(null);
    } catch (e) {
      return Left('Error al eliminar evento: $e');
    }
  }

  @override
  Future<Either<String, EventEntity>> getNextEvent() async {
    try {
      final event = await _remoteDatasource.getNextEvent();
      if (event == null) return const Left('No hay eventos próximos');
      return Right(event);
    } catch (e) {
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, void>> triggerNotifications(String eventId, String changeType) async {
    try {
      await _remoteDatasource.triggerNotifications(eventId, changeType);
      return const Right(null);
    } catch (e) {
      return Left('Error al notificar cambios: $e');
    }
  }
}
