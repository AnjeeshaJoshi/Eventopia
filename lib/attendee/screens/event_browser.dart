import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'event_detail_screen.dart';

class EventBrowser extends StatefulWidget {
  @override
  State<EventBrowser> createState() => EventBrowserState();
}

class EventBrowserState extends State<EventBrowser> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final all = context.watch<EventProvider>().events;
    final filtered = _query.isEmpty
        ? all
        : all
        .where((e) =>
    e.title.toLowerCase().contains(_query.toLowerCase()) ||
        e.organizerName.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(l.exploreEvents)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(fontSize: 14, color: C.t1),
              decoration: InputDecoration(
                hintText: l.searchEvents,
                prefixIcon:
                const Icon(Icons.search_rounded, color: C.t3, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: C.t3, size: 18),
                  onPressed: () => setState(() => _query = ''),
                )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                child: Text(l.noEventsMatchSearch,
                    style: const TextStyle(color: C.t2)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: EventCard(
                  event: filtered[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: filtered[i]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}