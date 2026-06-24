import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/app_provider.dart';
import '../theme.dart';
import '../widgets.dart';
import 'widgets/create_event_sheet.dart';
import 'widgets/event_detail_sheet.dart';

class OrgEvents extends StatelessWidget {
  const OrgEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final myEvents = context.watch<AppProvider>().myEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const CreateEventSheet(),
        ),
        backgroundColor: C.rose,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create'),
      ),


      body: myEvents.isEmpty
          ? const Center(
        child: Text(
          'No events yet.',
          style: TextStyle(color: C.t2),
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