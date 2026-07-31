import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'widgets/create_event_sheet.dart';
import 'widgets/event_detail_sheet.dart';

class OrgEvents extends StatelessWidget {
  const OrgEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final myEvents = eventProvider.getMyEvents(authProvider.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.myEvents),
      ),

      floatingActionButton: Semantics(
        label: l.createEvent,
        child: Container(
          decoration: BoxDecoration(
            gradient: C.gPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: FloatingActionButton.extended(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const CreateEventSheet(),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text(l.createEvent),
          ),
        ),
      ),

      body: myEvents.isEmpty
          ? Center(
        child: Text(
          l.noEventsYet,
          style: const TextStyle(color: C.t2),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          kBottomNavigationBarHeight + 24,
        ),
        itemCount: myEvents.length,
        itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: EventCard(
            event: myEvents[i],
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) =>
                  EventDetailSheet(event: myEvents[i]),
            ),
          ),
        ),
      ),
    );
  }
}