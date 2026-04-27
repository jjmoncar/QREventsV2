import 'package:dartz/dartz.dart';
import '../entities/guest.dart';

abstract class GuestRepository {
  Future<Either<String, List<GuestEntity>>> getGuests(String eventId);
  Future<Either<String, GuestEntity>> getGuest(String id);
  Future<Either<String, GuestEntity>> addGuest(GuestEntity guest);
  Future<Either<String, GuestEntity>> updateGuest(GuestEntity guest);
  Future<Either<String, void>> deleteGuest(String id);
  Future<Either<String, List<GuestEntity>>> searchGuests(
      String eventId, String query);
  Future<Either<String, void>> sendInvitation(String guestId, String channel);
}
