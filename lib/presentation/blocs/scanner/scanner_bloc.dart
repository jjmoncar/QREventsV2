import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/qr_repository.dart';
import 'scanner_event.dart';
import 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final QrRepository _qrRepository;

  ScannerBloc(this._qrRepository) : super(ScannerReady()) {
    on<ScanQrCode>(_onScanQr);
    on<FetchGuestInfo>(_onFetchGuest);
    on<ResetScanner>(_onReset);
  }

  Future<void> _onFetchGuest(
      FetchGuestInfo event, Emitter<ScannerState> emit) async {
    emit(ScannerProcessing());
    final result = await _qrRepository.getGuestByToken(event.qrToken);
    result.fold(
      (error) => emit(ScannerError(error)),
      (guest) => emit(GuestInfoLoaded(event.qrToken, guest)),
    );
  }

  Future<void> _onScanQr(
      ScanQrCode event, Emitter<ScannerState> emit) async {
    emit(ScannerProcessing());
    final result = await _qrRepository.validateQr(
      event.qrToken,
      event.scannedBy,
      count: event.count,
    );
    result.fold(
      (error) => emit(ScannerError(error)),
      (validation) => emit(ScannerResult(validation)),
    );
  }

  void _onReset(ResetScanner event, Emitter<ScannerState> emit) {
    emit(ScannerReady());
  }
}
