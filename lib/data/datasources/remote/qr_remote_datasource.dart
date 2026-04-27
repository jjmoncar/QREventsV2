import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/qr_validation.dart';

class QrRemoteDatasource {
  final SupabaseClient _client;

  QrRemoteDatasource(this._client);

  Future<QrValidationResult> validateQr(
      String qrToken, String scannedBy,
      {int count = 1}) async {
    final response = await _client.rpc('validate_qr', params: {
      'p_qr_token': qrToken,
      'p_scanned_by': scannedBy,
      'p_count': count,
    });

    return QrValidationResult.fromJson(response as Map<String, dynamic>);
  }
}
