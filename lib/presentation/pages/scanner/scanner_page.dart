import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vibration/vibration.dart';

import '../../../core/constants/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../domain/entities/qr_validation.dart';
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
  int _groupCount = 1;
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
        if (state is ScannerResult) {
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

            // Group Counter (bottom)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.peopleEntering,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.white),
                          onPressed: _groupCount > 1
                              ? () => setState(() => _groupCount--)
                              : null,
                        ),
                        Text(
                          '$_groupCount',
                          style: const TextStyle(
                            color: AppColors.secondaryTealLight,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle,
                              color: Colors.white),
                          onPressed: () =>
                              setState(() => _groupCount++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.pointCameraAtQr,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
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
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    context.read<ScannerBloc>().add(
          ScanQrCode(
            qrToken: barcode!.rawValue!,
            scannedBy: userId,
            count: _groupCount,
          ),
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
                  setState(() => _groupCount = 1);
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
