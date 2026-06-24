import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../widgets.dart';
import '../widgets/admin_event_action_sheet.dart';

class EventViewer extends StatelessWidget {
  const EventViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<AppProvider>().events;

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Expanded(
            child: events.isEmpty
                ? const Center(
              child: Text('No events available'),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: EventCard(
                  event: events[i],
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AdminEventActionSheet(event: events[i]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}