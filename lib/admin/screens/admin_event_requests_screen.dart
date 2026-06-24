import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminEventRequestsScreen extends StatelessWidget {
  const AdminEventRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final pending = p.pendingEvents;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Event Requests',
          style: TextStyle(fontWeight: FontWeight.w700),
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
                  const Text(
                    'No pending requests',
                    style: TextStyle(fontSize: 16, color: C.t2, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: pending.length,
              itemBuilder: (context, index) {
                final event = pending[index];
                return _buildRequestCard(context, event, p);
              },
            ),
    );
  }

  Widget _buildRequestCard(BuildContext context, AppEvent event, AppProvider p) {
    return GCard(
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
                      'By ${event.organizerName}',
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
                  event.location,
                  style: const TextStyle(fontSize: 13, color: C.t2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: C.t3),
              const SizedBox(width: 6),
              Text(
                DateFormat('MMM dd, yyyy').format(event.date),
                style: const TextStyle(fontSize: 13, color: C.t2),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded, size: 16, color: C.t3),
              const SizedBox(width: 6),
              Text(
                '${event.start.format(context)} - ${event.end.format(context)}',
                style: const TextStyle(fontSize: 13, color: C.t2),
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
                child: OutlinedButton(
                  onPressed: () {
                    p.rejectEvent(event.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event rejected')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: C.rose,
                    side: const BorderSide(color: C.rose),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    p.approveEvent(event.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event approved')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: C.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
