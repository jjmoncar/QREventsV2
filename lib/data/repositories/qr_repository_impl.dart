import 'package:dartz/dartz.dart';
import '../../domain/entities/qr_validation.dart';
import '../../domain/repositories/qr_repository.dart';
import '../datasources/remote/qr_remote_datasource.dart';

class QrRepositoryImpl implements QrRepository {
  final QrRemoteDatasource _remoteDatasource;

  QrRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<String, QrValidationResult>> validateQr(
      String qrToken, String scannedBy,
      {int count = 1}) async {
    try {
      final result = await _remoteDatasource.validateQr(
        qrToken,
        scannedBy,
        count: count,
      );
      return Right(result);
    } catch (e) {
      return Left('Error al validar QR: $e');
    }
  }
}
