import 'package:flutter/material.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../theme.dart';
import '../../widgets.dart';

class QRScanDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: C.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(l.scanAttendeeQr,
                  style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner_rounded,
                        size: 64, color: C.teal),
                    const SizedBox(height: 8),
                    Text(l.cameraOpensHere,
                        style: const TextStyle(fontSize: 12, color: C.t2)),
                    Text(l.mobileScannerPlugin,
                        style: const TextStyle(fontSize: 10, color: C.t3)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              child: GBtn(
                label: l.close,
                onTap: () => Navigator.pop(context),
                gradient: C.gPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}