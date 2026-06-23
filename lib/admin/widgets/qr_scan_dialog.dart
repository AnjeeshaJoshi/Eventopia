import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets.dart';

class QRScanDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: C.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scan Attendee QR',
                style:
                TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: C.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner_rounded,
                        size: 64, color: C.teal),
                    SizedBox(height: 8),
                    Text('Camera opens here',
                        style: TextStyle(fontSize: 12, color: C.t2)),
                    Text('(mobile_scanner plugin)',
                        style: TextStyle(fontSize: 10, color: C.t3)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GBtn(
              label: 'Close',
              onTap: () => Navigator.pop(context),
              gradient: C.gPrimary,
            ),
          ],
        ),
      ),
    );
  }
}