import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class SoldOutSheet extends StatefulWidget {
  final AppEvent event;

  const SoldOutSheet({required this.event});

  @override
  State<SoldOutSheet> createState() => _SoldOutSheetState();
}

class _SoldOutSheetState extends State<SoldOutSheet> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final p = context.read<AppProvider>();
    final alreadyOn = p.isOnWaitlist(widget.event.id);

    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: C.border, borderRadius: BorderRadius.circular(2)),
          ),
          const Icon(Icons.event_busy_rounded, size: 48, color: C.rose),
          const SizedBox(height: 12),
          Text(widget.event.title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          const Text('This event is sold out.',
              style: TextStyle(fontSize: 14, color: C.t2)),
          const SizedBox(height: 20),
          if (_joined || alreadyOn) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.teal.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.teal.withOpacity(.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: C.teal, size: 18),
                  SizedBox(width: 8),
                  Text("You're on the waitlist!",
                      style: TextStyle(
                          color: C.teal, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ] else
            ...[
              const Text(
                'Join the waitlist — we\'ll notify you when tickets become available.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: C.t2),
              ),
              const SizedBox(height: 16),
              GBtn(
                label: 'Join Waitlist',
                onTap: () {
                  p.joinWaitlist(widget.event.id);
                  setState(() => _joined = true);
                },
                gradient: C.gRose,
                icon: Icons.notifications_rounded,
              ),
            ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: C.t2)),
          ),
        ],
      ),
    );
  }
}