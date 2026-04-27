import 'package:dartz/dartz.dart';
import '../../domain/entities/guest.dart';
import '../../domain/repositories/guest_repository.dart';
import '../datasources/remote/guest_remote_datasource.dart';
import '../models/guest_model.dart';

class GuestRepositoryImpl implements GuestRepository {
  final GuestRemoteDatasource _remoteDatasource;

  GuestRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<String, List<GuestEntity>>> getGuests(String eventId) async {
    try {
      final guests = await _remoteDatasource.getGuests(eventId);
      return Right(guests);
    } catch (e) {
      return Left('Error al obtener invitados: $e');
    }
  }

  @override
  Future<Either<String, GuestEntity>> getGuest(String id) async {
    try {
      final guest = await _remoteDatasource.getGuest(id);
      return Right(guest);
    } catch (e) {
      return Left('Error al obtener invitado: $e');
    }
  }

  @override
  Future<Either<String, GuestEntity>> addGuest(GuestEntity guest) async {
    try {
      final model = GuestModel(
        id: '',
        eventId: guest.eventId,
        name: guest.name,
        email: guest.email,
        whatsapp: guest.whatsapp,
        telegram: guest.telegram,
        phone: guest.phone,
        totalGuests: guest.totalGuests,
        notes: guest.notes,
      );
      final created = await _remoteDatasource.addGuest(model.toJson());
      return Right(created);
    } catch (e) {
      return Left('Error al agregar invitado: $e');
    }
  }

  @override
  Future<Either<String, GuestEntity>> updateGuest(GuestEntity guest) async {
    try {
      final model = GuestModel(
        id: guest.id,
        eventId: guest.eventId,
        name: guest.name,
        email: guest.email,
        whatsapp: guest.whatsapp,
        telegram: guest.telegram,
        phone: guest.phone,
        totalGuests: guest.totalGuests,
        notes: guest.notes,
      );
      final updated =
          await _remoteDatasource.updateGuest(guest.id, model.toJson());
      return Right(updated);
    } catch (e) {
      return Left('Error al actualizar invitado: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteGuest(String id) async {
    try {
      await _remoteDatasource.deleteGuest(id);
      return const Right(null);
    } catch (e) {
      return Left('Error al eliminar invitado: $e');
    }
  }

  @override
  Future<Either<String, List<GuestEntity>>> searchGuests(
      String eventId, String query) async {
    try {
      final guests = await _remoteDatasource.searchGuests(eventId, query);
      return Right(guests);
    } catch (e) {
      return Left('Error en la búsqueda: $e');
    }
  }

  @override
  Future<Either<String, void>> sendInvitation(String guestId, String channel) async {
    try {
      await _remoteDatasource.sendInvitation(guestId, channel);
      return const Right(null);
    } catch (e) {
      return Left('Error al enviar invitación: $e');
    }
  }
}
