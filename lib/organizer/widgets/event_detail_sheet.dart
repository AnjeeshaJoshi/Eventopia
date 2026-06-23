import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import '../../widgets.dart';

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
            Text(event.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
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
                      TicketChip(cat: t.category),
                      const Spacer(),
                      Text('MYR ${t.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('${t.sold}/${t.capacity}',
                          style: const TextStyle(fontSize: 12, color: C.t2)),
                    ],
                  ),
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
                        const Icon(Icons.discount_rounded,
                            color: C.rose, size: 16),
                        const SizedBox(width: 8),
                        Text(p.code,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace')),
                        const Spacer(),
                        Text('${p.discountPct.toStringAsFixed(0)}% off',
                            style:
                                const TextStyle(fontSize: 12, color: C.rose)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
