import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ems_app/providers/event_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminEventRequestsScreen extends StatelessWidget {
  const AdminEventRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final pending = eventProvider.pendingEvents;
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          l.eventRequests,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: pending.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available_rounded, size: 64, color: C.t3.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l.noPendingRequests,
                    style: const TextStyle(fontSize: 16, color: C.t2, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: pending.length,
              itemBuilder: (context, index) {
                final event = pending[index];
                return _buildRequestCard(context, event, eventProvider, l);
              },
            ),
    );
  }

  Widget _buildRequestCard(BuildContext context, EventModel event, EventProvider eventProvider, AppLocalizations l) {
    return Semantics(
      label: l.eventRequestCard,
      child: GCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: C.violet.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.event_note_rounded, color: C.violet),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: C.t1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.byOrganizer(event.organizerName),
                        style: const TextStyle(fontSize: 14, color: C.t2, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: C.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    EventStatus.pending.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: C.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: C.t3),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    event.venue,
                    style: const TextStyle(fontSize: 13, color: C.t2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: C.t3),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM dd, yyyy').format(event.date),
                      style: const TextStyle(fontSize: 13, color: C.t2),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: C.t3),
                    const SizedBox(width: 6),
                    Text(
                      '${event.start.format(context)} - ${event.end.format(context)}',
                      style: const TextStyle(fontSize: 13, color: C.t2),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: const TextStyle(fontSize: 13, color: C.t2, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    button: true,
                    label: l.reject,
                    child: OutlinedButton(
                      onPressed: () async {
                        try {
                          await eventProvider.rejectEvent(event.eventId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l.eventRejected)),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: C.rose,
                        side: const BorderSide(color: C.rose),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l.reject, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: l.approve,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          await eventProvider.approveEvent(event.eventId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l.eventApproved)),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: C.teal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(l.approve, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
