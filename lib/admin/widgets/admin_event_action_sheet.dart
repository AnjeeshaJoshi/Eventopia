import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminEventActionSheet extends StatefulWidget {
  final EventModel event;

  const AdminEventActionSheet({super.key, required this.event});

  @override
  State<AdminEventActionSheet> createState() => _AdminEventActionSheetState();
}

class _AdminEventActionSheetState extends State<AdminEventActionSheet> {
  late EventStatus _status;

  String _statusLabel(BuildContext context, EventStatus status) {
    final language = Localizations.localeOf(context).languageCode;
    if (language == 'hi') {
      switch (status) {
        case EventStatus.planned: return 'नियोजित';
        case EventStatus.pending: return 'लंबित';
        case EventStatus.upcoming: return 'आगामी';
        case EventStatus.ongoing: return 'चल रहा है';
        case EventStatus.completed: return 'समाप्त';
        case EventStatus.cancelled: return 'रद्द';
        case EventStatus.postponed: return 'स्थगित';
      }
    }
    if (language == 'ne') {
      switch (status) {
        case EventStatus.planned: return 'योजनाबद्ध';
        case EventStatus.pending: return 'विचाराधीन';
        case EventStatus.upcoming: return 'आगामी';
        case EventStatus.ongoing: return 'चलिरहेको';
        case EventStatus.completed: return 'समाप्त';
        case EventStatus.cancelled: return 'रद्द';
        case EventStatus.postponed: return 'स्थगित';
      }
    }
    return status.label;
  }

  @override
  void initState() {
    super.initState();
    _status = widget.event.status;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Semantics(
            label: l.manageEvent,
            child: Text(l.manageEvent, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(l.changeStatus, style: const TextStyle(fontWeight: FontWeight.w600, color: C.t2)),
          ),
          const SizedBox(height: 8),
          ...EventStatus.values.map((s) {
            return RadioListTile<EventStatus>(
              title: Text(_statusLabel(context, s)),
              value: s,
              groupValue: _status,
              activeColor: C.violet,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            );
          }),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: GBtn(
                  label: l.deleteEvent,
                  gradient: C.gPrimary,
                  onTap: () {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l.deleteEvent),
                        content: Text(l.areYouSureDeleteEvent),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l.cancel),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await context.read<EventProvider>().deleteEvent(widget.event.eventId);
                                if (ctx.mounted) Navigator.pop(ctx); // Close dialog
                                if (context.mounted) Navigator.pop(context); // Close bottom sheet
                              } catch (e) {
                                if (ctx.mounted) {
                                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString())));
                                }
                              }
                            },
                            child: Text(l.delete, style: const TextStyle(color: C.rose)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GBtn(
                  label: l.saveChanges,
                  onTap: () async {
                    try {
                      await context.read<EventProvider>().updateEventStatus(widget.event.eventId, _status);
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
