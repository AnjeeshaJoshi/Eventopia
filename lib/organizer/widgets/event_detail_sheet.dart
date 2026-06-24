import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'edit_event_sheet.dart';

class EventDetailSheet extends StatelessWidget {
  final AppEvent event;

  const EventDetailSheet({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .75,
      minChildSize: .4,
      maxChildSize: .95,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ListView(
          controller: sc,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: C.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(event.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
                if (context.read<AppProvider>().current?.id == event.organizerId)
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, color: C.violet),
                    onPressed: () {
                      Navigator.pop(context); // Close detail sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => EditEventSheet(event: event),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(event.description,
                style: const TextStyle(fontSize: 13, color: C.t2)),
            const SizedBox(height: 16),
            const Divider(color: C.border),
            InfoRow(
                icon: Icons.calendar_today_rounded,
                label: 'Date',
                value: DateFormat('EEE, MMM d, y').format(event.date)),
            InfoRow(
                icon: Icons.access_time_rounded,
                label: 'Time',
                value:
                    '${event.start.format(context)} – ${event.end.format(context)}'),
            InfoRow(
                icon: Icons.event_seat_rounded,
                label: 'Seats',
                value: '${event.bookedSeats} / ${event.totalSeats}'),
            const Divider(color: C.border),
            const SizedBox(height: 12),
            const Text('Ticket Types',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...event.ticketTypes.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TicketChip(cat: t.category),
                      ),

                      const SizedBox(width: 6),

                      Flexible(
                        child: Text(
                          'NPR ${t.price.toStringAsFixed(0)}',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        '${t.sold}/${t.capacity}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: C.t2,
                        ),
                      ),
                    ],
                  )
                )),
            if (event.promoCodes.isNotEmpty) ...[
              const Divider(color: C.border),
              const Text('Promo Codes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ...event.promoCodes.map((p) => GCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.discount_rounded,
                          color: C.rose,
                          size: 16,
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            p.code,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),

                        Text(
                          '${p.discountPct.toStringAsFixed(0)}% off',
                          style: const TextStyle(
                            fontSize: 12,
                            color: C.rose,
                          ),
                        ),
                      ],
                    )
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
