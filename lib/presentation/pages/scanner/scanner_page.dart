import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/qr_validation.dart';
import '../../../domain/entities/guest.dart';
import '../../blocs/scanner/scanner_bloc.dart';
import '../../blocs/scanner/scanner_event.dart';
import '../../blocs/scanner/scanner_state.dart';

class ScannerPage extends StatefulWidget {
  final String eventId;
  const ScannerPage({super.key, required this.eventId});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _isProcessing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerBloc, ScannerState>(
      listener: (context, state) async {
        if (state is GuestInfoLoaded) {
          _isProcessing = false;
          if (mounted) {
            _handleGuestInfo(state.qrToken, state.guest as GuestEntity);
          }
        } else if (state is ScannerResult) {
          _isProcessing = false;
          // Haptic feedback
          if ((await Vibration.hasVibrator()) == true) {
            Vibration.vibrate(duration: state.result.isSuccess ? 100 : 300);
          }
          if (mounted) {
            _showResultOverlay(state.result);
          }
        } else if (state is ScannerError) {
          _isProcessing = false;
          if (mounted) {
            _cameraController.start(); // Restart camera on error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(AppLocalizations.of(context)!.qrScanner),
          actions: [
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: _cameraController,
                builder: (context, state, child) {
                  if (state.torchState == TorchState.on) {
                    return const Icon(Icons.flash_on, color: Colors.amber);
                  }
                  return const Icon(Icons.flash_off, color: Colors.white);
                },
              ),
              onPressed: () => _cameraController.toggleTorch(),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Camera
            MobileScanner(
              controller: _cameraController,
              onDetect: _onDetect,
            ),

            // Scan Overlay
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.secondaryTealLight,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Corner Markers
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  children: [
                    _cornerMarker(Alignment.topLeft),
                    _cornerMarker(Alignment.topRight),
                    _cornerMarker(Alignment.bottomLeft),
                    _cornerMarker(Alignment.bottomRight),
                  ],
                ),
              ),
            ),

            // Info Text (bottom)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Text(
                AppLocalizations.of(context)!.pointCameraAtQr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    _isProcessing = true;
    _cameraController.stop(); // Stop camera while processing or showing dialog
    
    context.read<ScannerBloc>().add(FetchGuestInfo(barcode!.rawValue!));
  }

  void _handleGuestInfo(String token, GuestEntity guest) async {
    int count = 1;
    
    // If guest is part of a group, ask for count
    if (guest.totalGuests > 1) {
      final pickedCount = await _showGroupCountDialog(guest);
      if (pickedCount == null) {
        // User cancelled the dialog
        _isProcessing = false;
        _cameraController.start();
        context.read<ScannerBloc>().add(ResetScanner());
        return;
      }
      count = pickedCount;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    if (mounted) {
      context.read<ScannerBloc>().add(
            ScanQrCode(
              qrToken: token,
              scannedBy: userId,
              count: count,
            ),
          );
    }
  }

  Future<int?> _showGroupCountDialog(GuestEntity guest) async {
    int currentCount = guest.totalGuests - guest.guests_checked_in;
    if (currentCount <= 0) return 1; // Should not happen if SQL logic is right

    return await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        int tempCount = currentCount;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(guest.name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿Cuántas personas están ingresando?'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: tempCount > 1
                            ? () => setDialogState(() => tempCount--)
                            : null,
                      ),
                      Text(
                        '$tempCount',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: tempCount < currentCount
                            ? () => setDialogState(() => tempCount++)
                            : null,
                      ),
                    ],
                  ),
                  Text(
                    'Máximo disponible: $currentCount',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(null),
                  child: const Text('CANCELAR'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(tempCount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNavy,
                  ),
                  child: const Text('CONFIRMAR'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResultOverlay(QrValidationResult result) {
    Color bgColor;
    IconData icon;

    switch (result.type) {
      case QrValidationType.full:
        bgColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case QrValidationType.partial:
        bgColor = AppColors.warning;
        icon = Icons.info;
        break;
      case QrValidationType.cancelled:
        bgColor = AppColors.error;
        icon = Icons.block;
        break;
      default:
        bgColor = AppColors.error;
        icon = Icons.cancel;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 64),
            const SizedBox(height: 16),
            Text(
              result.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (result.remaining != null && result.remaining! > 0) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.remainingSlots(result.remaining!),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.read<ScannerBloc>().add(ResetScanner());
                  _cameraController.start(); // Restart camera
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: bgColor,
                ),
                child: Text(AppLocalizations.of(context)!.continueScanning),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cornerMarker(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border(
            top: alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(
                    color: AppColors.secondaryTealLight, width: 4)
                : BorderSide.none,
            bottom: alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(
                    color: AppColors.secondaryTealLight, width: 4)
                : BorderSide.none,
            left: alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(
                    color: AppColors.secondaryTealLight, width: 4)
                : BorderSide.none,
            right: alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(
                    color: AppColors.secondaryTealLight, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
