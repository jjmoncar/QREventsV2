import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<String, UserEntity>> login(
      String email, String password) async {
    try {
      final user = await _remoteDatasource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> register(
      String email, String password, String name) async {
    try {
      final user = await _remoteDatasource.register(email, password, name);
      return Right(user);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  @override
  Future<Either<String, void>> verifyEmail(String token) async {
    try {
      await _remoteDatasource.verifyEmail(token);
      return const Right(null);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> getCurrentUser() async {
    try {
      final user = await _remoteDatasource.getCurrentUser();
      if (user == null) return const Left('No hay sesión activa');
      return Right(user);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  @override
  Future<Either<String, void>> logout() async {
    try {
      await _remoteDatasource.logout();
      return const Right(null);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  @override
  Future<Either<String, UserEntity>> updateProfile(
      {String? name, String? avatarUrl}) async {
    try {
      final userId = (await _remoteDatasource.getCurrentUser())?.id;
      if (userId == null) return const Left('No autenticado');
      final user = await _remoteDatasource.updateProfile(userId,
          name: name, avatarUrl: avatarUrl);
      return Right(user);
    } catch (e) {
      return Left(_parseError(e));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('Invalid login credentials')) {
      return 'Credenciales inválidas';
    }
    if (msg.contains('User already registered')) {
      return 'El correo ya está registrado';
    }
    if (msg.contains('Email not confirmed')) {
      return 'Confirma tu correo electrónico';
    }
    return 'Error: $msg';
  }
}
