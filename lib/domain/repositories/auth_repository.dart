import 'package:dartz/dartz.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> login(String email, String password);
  Future<Either<String, UserEntity>> register(
      String email, String password, String name);
  Future<Either<String, void>> verifyEmail(String token);
  Future<Either<String, UserEntity>> getCurrentUser();
  Future<Either<String, void>> logout();
  Future<Either<String, UserEntity>> updateProfile(
      {String? name, String? avatarUrl});
}
