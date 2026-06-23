import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../auth/app_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';

class CheckInTab extends StatefulWidget {
  const CheckInTab({super.key});

  @override
  State<CheckInTab> createState() => _CheckInTabState();
}

class _CheckInTabState extends State<CheckInTab> {
  final _ctrl = TextEditingController();
  String? _result;
  bool _success = false;

  void _scan() {
    final qr = _ctrl.text.trim();
    if (qr.isEmpty) return;
    final title = context.read<AppProvider>().checkIn(qr);
    setState(() {
      _success = title != null;
      _result = title != null
          ? 'Entry approved for "$title"'
          : 'QR code not found or already used.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          AppBar(title: const Text('QR Check-In')), // optional header UI

          const SizedBox(height: 16),

          GCard(
            borderColor: C.teal.withOpacity(.3),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: QrImageView(
                    data: 'EMS-DEMO-QR-SCAN',
                    version: QrVersions.auto,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Scan QR at entry gate',
                  style: TextStyle(fontSize: 13, color: C.t2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          GCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manual QR Code Entry',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                AppField(
                  label: 'Enter QR Code',
                  controller: _ctrl,
                  prefix: Icons.qr_code_rounded,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: GBtn(
                    label: 'Validate Entry',
                    onTap: _scan,
                    gradient: C.gTeal,
                    icon: Icons.check_circle_rounded,
                  ),
                ),
                if (_result != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_success ? C.teal : C.rose).withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: (_success ? C.teal : C.rose).withOpacity(.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _success
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: _success ? C.teal : C.rose,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _result!,
                            style: TextStyle(
                              fontSize: 13,
                              color: _success ? C.teal : C.rose,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}