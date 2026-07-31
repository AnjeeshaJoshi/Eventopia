import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../widgets.dart';
import '../widgets/admin_event_action_sheet.dart';

class EventViewer extends StatelessWidget {
  const EventViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final events = context.watch<EventProvider>().events;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l.allEvents,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Expanded(
            child: events.isEmpty
                ? Center(
              child: Text(l.noEventsAvailable),
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