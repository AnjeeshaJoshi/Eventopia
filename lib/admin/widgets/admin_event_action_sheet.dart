import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminEventActionSheet extends StatefulWidget {
  final AppEvent event;

  const AdminEventActionSheet({super.key, required this.event});

  @override
  State<AdminEventActionSheet> createState() => _AdminEventActionSheetState();
}

class _AdminEventActionSheetState extends State<AdminEventActionSheet> {
  late EventStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.event.status;
  }

  @override
  Widget build(BuildContext context) {
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
          const Text('Manage Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Change Status', style: TextStyle(fontWeight: FontWeight.w600, color: C.t2)),
          ),
          const SizedBox(height: 8),
          ...EventStatus.values.map((s) {
            return RadioListTile<EventStatus>(
              title: Text(s.label),
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
                  label: 'Delete Event',
                  color: C.rose,
                  onTap: () {
                    // Show confirmation dialog before deleting
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Event'),
                        content: const Text('Are you sure you want to delete this event? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<AppProvider>().deleteEvent(widget.event.id);
                              Navigator.pop(ctx); // Close dialog
                              Navigator.pop(context); // Close bottom sheet
                            },
                            child: const Text('Delete', style: TextStyle(color: C.rose)),
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
                  label: 'Save Changes',
                  onTap: () {
                    context.read<AppProvider>().updateEventStatus(widget.event.id, _status);
                    Navigator.pop(context);
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
