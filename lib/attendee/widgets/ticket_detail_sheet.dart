import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class TicketDetailSheet extends StatelessWidget {
  final Booking booking;
  const TicketDetailSheet({required this.booking});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .8,
      maxChildSize: .95,
      minChildSize: .4,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: ListView(
          controller: sc,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: C.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text(booking.eventTitle,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),

            Center(
              child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: booking.qrData,
                  version: QrVersions.auto,
                ),
              ),
            ),

            const SizedBox(height: 16),

            GCard(
              child: Column(
                children: [
                  InfoRow(
                      icon: Icons.confirmation_number_rounded,
                      label: 'Ticket Type',
                      value:
                      '${booking.category.label} × ${booking.quantity}'),
                  InfoRow(
                      icon: Icons.event_seat_rounded,
                      label: 'Section',
                      value: booking.category.section),
                  InfoRow(
                      icon: Icons.payments_rounded,
                      label: 'Total Paid',
                      value: 'NPR ${booking.total.toStringAsFixed(2)}'),
                  InfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Booked On',
                      value: DateFormat('dd MMM y').format(booking.createdAt)),
                  InfoRow(
                      icon: Icons.tag_rounded,
                      label: 'Ref',
                      value: booking.id.substring(0, 8).toUpperCase()),
                ],
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                final cancelled = context
                    .read<AppProvider>()
                    .cancelBooking(booking.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(cancelled
                      ? 'Booking cancelled.'
                      : 'Cannot cancel — 7-day window has passed.'),
                ));
              },
              icon: const Icon(Icons.cancel_rounded, color: C.rose),
              label: const Text('Cancel Booking',
                  style: TextStyle(color: C.rose)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: C.rose),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// GBtn extension for fixed width
extension _GBtnExt on GBtn {
  GBtn withWidth(double w) => GBtn(
      label: label, onTap: onTap, gradient: gradient, loading: loading);
}