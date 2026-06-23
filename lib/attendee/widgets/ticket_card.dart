import 'package:flutter/material.dart';
import 'ticket_detail_sheet.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class TicketCard extends StatelessWidget {
  final Booking booking;
  const TicketCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return GCard(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => TicketDetailSheet(booking: booking),
      ),
      child: Row(
        children: [
          // QR thumbnail
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(6),
            child: QrImageView(
              data: booking.qrData,
              version: QrVersions.auto,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.eventTitle,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    TicketChip(cat: booking.category),
                    const SizedBox(width: 6),
                    Text('× ${booking.quantity}',
                        style: const TextStyle(
                            fontSize: 12, color: C.t2)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('NPR ${booking.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: C.teal)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: C.t3),
        ],
      ),
    );
  }
}