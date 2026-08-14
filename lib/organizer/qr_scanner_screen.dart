import 'package:ems_app/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../theme.dart';

class QrScannerScreen extends StatefulWidget {
  final EventModel? event;
  final String organizerId;

  const QrScannerScreen({
    super.key,
    required this.event,
    required this.organizerId,
  });

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  final ImagePicker _imagePicker = ImagePicker();

  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? code = barcodes.first.rawValue;
    if (code == null) return;

    _verifyCode(code);
  }

  Future<void> _verifyCode(
    String code, {
    bool scannerAlreadyStopped = false,
  }) async {
    if (_isProcessing && !scannerAlreadyStopped) return;

    if (!_isProcessing) setState(() => _isProcessing = true);
    if (!scannerAlreadyStopped) await _controller.stop();

    final l = AppLocalizations.of(context)!;
    String resultMsg;
    bool isSuccess = false;

    try {
      final result = await context.read<BookingProvider>().verifyTicket(
        code,
        widget.event,
        widget.organizerId,
      );

      isSuccess = result['status'];
      resultMsg = result['message'];
    } catch (e) {
      isSuccess = false;
      resultMsg = e.toString();
    }

    if (mounted) {
      await _showScanResultDialog(isSuccess, resultMsg, l);

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        await _controller.start();
      }
    }
  }

  Future<void> _showScanResultDialog(
    bool isSuccess,
    String resultMessage,
    AppLocalizations l,
  ) {
    final normalizedMessage = resultMessage.toLowerCase();
    final isDuplicate = normalizedMessage.contains('already checked in');
    final isCancelled = normalizedMessage.contains('cancelled');
    final isMismatch = normalizedMessage.contains('mismatch') ||
        normalizedMessage.contains('another organizer') ||
        normalizedMessage.contains('event not found');

    final color = isSuccess ? C.teal : isMismatch ? C.amber : C.rose;
    final icon = isSuccess
        ? Icons.verified_rounded
        : isDuplicate
            ? Icons.history_toggle_off_rounded
            : isCancelled
                ? Icons.cancel_rounded
                : isMismatch
                    ? Icons.event_busy_rounded
                    : Icons.qr_code_scanner_rounded;
    final title = isSuccess
        ? l.ticketVerified
        : isDuplicate
            ? 'Ticket already used'
            : isCancelled
                ? 'Ticket cancelled'
                : isMismatch
                    ? 'Wrong event ticket'
                    : l.scanFailed;
    final guidance = isSuccess
        ? 'Entry approved. You can welcome this attendee in.'
        : isDuplicate
            ? 'This ticket has already been checked in and cannot be used again.'
            : isCancelled
                ? 'This booking has been cancelled and is not valid for entry.'
                : isMismatch
                    ? 'Scan a ticket issued for the selected event.'
                    : 'Ask the attendee to show a valid Eventopia ticket and try again.';

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: title,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (dialogContext, _, __) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 360,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(color: Color(0x33000000), blurRadius: 28, offset: Offset(0, 12)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: color.withOpacity(.14),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withOpacity(.3), width: 2),
                    ),
                    child: Icon(icon, color: color, size: 42),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: color),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    resultMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: C.t1),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(guidance, style: const TextStyle(fontSize: 12, color: C.t2, height: 1.35)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: Text(isSuccess ? 'Scan next ticket' : l.ok),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  Future<void> _selectFromGallery() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    await _controller.stop();

    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        await _resumeScanner();
        return;
      }

      final capture = await _controller.analyzeImage(image.path);
      final code = capture?.barcodes
          .map((barcode) => barcode.rawValue)
          .whereType<String>()
          .firstOrNull;
      if (code == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No QR code was found in that image.')),
          );
        }
        await _resumeScanner();
        return;
      }

      // The gallery picker has already paused the camera. Continue through the
      // same verification flow used for a live scan.
      await _verifyCode(code, scannerAlreadyStopped: true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to read the selected image.')),
        );
      }
      await _resumeScanner();
    }
  }

  Future<void> _resumeScanner() async {
    if (mounted) setState(() => _isProcessing = false);
    await _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.scanTicket),
        actions: [
          IconButton(
            tooltip: 'Select QR image from gallery',
            icon: const Icon(Icons.photo_library_outlined),
            onPressed: _isProcessing ? null : _selectFromGallery,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Overlay to make it look like a scanner
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: C.teal,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..moveTo(rect.left + rect.width / 2.0, rect.top + rect.height / 2.0)
      ..addRect(Rect.fromCenter(
        center: Offset(rect.left + rect.width / 2.0, rect.top + rect.height / 2.0),
        width: cutOutSize,
        height: cutOutSize,
      ));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength = borderLength > cutOutSize / 2 + borderWidth * 2 ? borderWidthSize / 2 : borderLength;
    final _cutOutSize = cutOutSize < width ? cutOutSize : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromCenter(
      center: Offset(rect.left + width / 2, rect.top + height / 2),
      width: _cutOutSize,
      height: _cutOutSize,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw the cutout
      ..drawRRect(
        RRect.fromRectAndCorners(
          cutOutRect,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();

    // Draws the corners
    // Top left
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.top + _borderLength)
        ..lineTo(cutOutRect.left, cutOutRect.top + borderRadius)
        ..arcToPoint(Offset(cutOutRect.left + borderRadius, cutOutRect.top),
            radius: Radius.circular(borderRadius))
        ..lineTo(cutOutRect.left + _borderLength, cutOutRect.top),
      borderPaint,
    );
    // Top right
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right - _borderLength, cutOutRect.top)
        ..lineTo(cutOutRect.right - borderRadius, cutOutRect.top)
        ..arcToPoint(Offset(cutOutRect.right, cutOutRect.top + borderRadius),
            radius: Radius.circular(borderRadius))
        ..lineTo(cutOutRect.right, cutOutRect.top + _borderLength),
      borderPaint,
    );
    // Bottom right
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.right, cutOutRect.bottom - _borderLength)
        ..lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius)
        ..arcToPoint(Offset(cutOutRect.right - borderRadius, cutOutRect.bottom),
            radius: Radius.circular(borderRadius))
        ..lineTo(cutOutRect.right - _borderLength, cutOutRect.bottom),
      borderPaint,
    );
    // Bottom left
    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left + _borderLength, cutOutRect.bottom)
        ..lineTo(cutOutRect.left + borderRadius, cutOutRect.bottom)
        ..arcToPoint(Offset(cutOutRect.left, cutOutRect.bottom - borderRadius),
            radius: Radius.circular(borderRadius))
        ..lineTo(cutOutRect.left, cutOutRect.bottom - _borderLength),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth * t,
      overlayColor: overlayColor,
      borderRadius: borderRadius * t,
      borderLength: borderLength * t,
      cutOutSize: cutOutSize * t,
    );
  }
}
