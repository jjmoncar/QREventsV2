import 'package:dartz/dartz.dart';
import '../entities/qr_validation.dart';

abstract class QrRepository {
  Future<Either<String, QrValidationResult>> validateQr(
      String qrToken, String scannedBy,
      {int count = 1});
}
