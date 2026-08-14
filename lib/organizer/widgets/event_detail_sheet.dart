import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../../attendee/widgets/event_location_map.dart';
import 'edit_event_sheet.dart';

class EventDetailSheet extends StatelessWidget {
  final EventModel event;

  const EventDetailSheet({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                if (context.read<AuthProvider>().currentUser?.uid == event.organizerId) ...[
                  Tooltip(
                    message: l.editEvent,
                    child: Semantics(
                      label: l.editEvent,
                      child: IconButton(
                        icon: const Icon(Icons.edit_rounded, color: C.violet),
                        onPressed: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => EditEventSheet(event: event),
                          );
                        },
                      ),
                    ),
                  ),
                  Tooltip(
                    message: l.deleteEvent,
                    child: Semantics(
                      label: l.deleteEvent,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: C.rose),
                        onPressed: () => _confirmDelete(context, l),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(event.description,
                style: const TextStyle(fontSize: 13, color: C.t2)),
            const SizedBox(height: 16),
            const Divider(color: C.border),
            InfoRow(
                icon: Icons.calendar_today_rounded,
                label: l.date,
                value: DateFormat('EEE, MMM d, y').format(event.date)),
            InfoRow(
                icon: Icons.access_time_rounded,
                label: l.time,
                value:
                    '${event.start.format(context)} – ${event.end.format(context)}'),
            InfoRow(
                icon: Icons.location_on_rounded,
                label: l.location,
                value: event.venue),
            InfoRow(
                icon: Icons.event_seat_rounded,
                label: l.seats,
                value: '${event.bookedSeats} / ${event.totalSeats}'),
            if (event.latitude != null && event.longitude != null) ...[
              const SizedBox(height: 12),
              EventLocationMap(event: event),
            ],
            const Divider(color: C.border),
            const SizedBox(height: 12),
            Text(l.ticketTypes,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
              Text(l.promoCodes,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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

  Future<void> _confirmDelete(BuildContext context, AppLocalizations l) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.deleteEvent),
        content: Text(l.areYouSureDeleteEvent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: C.rose),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !context.mounted) return;

    try {
      await context.read<EventProvider>().deleteEvent(event.eventId);
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.deleteEvent)),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to delete the event. Please try again.')),
      );
    }
  }
}
