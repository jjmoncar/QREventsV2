import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();
  @override
  List<Object?> get props => [];
}

class ScanQrCode extends ScannerEvent {
  final String qrToken;
  final String scannedBy;
  final int count;
  const ScanQrCode({
    required this.qrToken,
    required this.scannedBy,
    this.count = 1,
  });
  @override
  List<Object?> get props => [qrToken, scannedBy, count];
}

class ResetScanner extends ScannerEvent {}
