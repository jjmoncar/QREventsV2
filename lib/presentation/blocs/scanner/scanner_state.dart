import 'package:equatable/equatable.dart';
import '../../../domain/entities/qr_validation.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();
  @override
  List<Object?> get props => [];
}

class ScannerReady extends ScannerState {}

class ScannerProcessing extends ScannerState {}

class ScannerResult extends ScannerState {
  final QrValidationResult result;
  const ScannerResult(this.result);
  @override
  List<Object?> get props => [result];
}

class ScannerError extends ScannerState {
  final String message;
  const ScannerError(this.message);
  @override
  List<Object?> get props => [message];
}
