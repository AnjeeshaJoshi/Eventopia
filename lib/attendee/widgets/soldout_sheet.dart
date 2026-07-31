import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class SoldOutSheet extends StatefulWidget {
  final EventModel event;

  const SoldOutSheet({required this.event});

  @override
  State<SoldOutSheet> createState() => _SoldOutSheetState();
}

class _SoldOutSheetState extends State<SoldOutSheet> {
  bool _joined = false;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();
    _emailController.text = _emailController.text.isEmpty
        ? authProvider.currentUser!.email
        : _emailController.text;
    final alreadyOn = bookingProvider.isOnWaitlist(widget.event.eventId, authProvider.currentUser!.uid);

    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: C.border, borderRadius: BorderRadius.circular(2)),
          ),
          const Icon(Icons.event_busy_rounded, size: 48, color: C.rose),
          const SizedBox(height: 12),
          Text(widget.event.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(l.eventSoldOut,
              style: const TextStyle(fontSize: 14, color: C.t2)),
          const SizedBox(height: 20),
          if (_joined || alreadyOn) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: C.teal.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.teal.withOpacity(.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, color: C.teal, size: 18),
                  const SizedBox(width: 8),
                  Text(l.onWaitlist,
                      style: const TextStyle(
                          color: C.teal, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ] else ...[
            Text(
              l.joinWaitlistDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: C.t2),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email for availability notifications',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 12),
            GBtn(
              label: l.joinWaitlist,
              onTap: () async {
                try {
                  if (_emailController.text.trim().isEmpty) return;
                  await bookingProvider.joinWaitlist(
                    widget.event.eventId,
                    userId: authProvider.currentUser!.uid,
                    userName: authProvider.currentUser!.name,
                    email: _emailController.text.trim(),
                  );
                  setState(() => _joined = true);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              },
              gradient: C.gRose,
              icon: Icons.notifications_rounded,
            ),
          ],
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.close, style: const TextStyle(color: C.t2)),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
