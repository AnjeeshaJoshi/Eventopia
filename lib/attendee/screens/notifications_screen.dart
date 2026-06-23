import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    if (p.current == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final notifs = p.getUserNotifications(p.current!.id);

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: notifs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 64, color: C.t3),
                  const SizedBox(height: 16),
                  const Text('No notifications yet', style: TextStyle(color: C.t2, fontSize: 16)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifs.length,
              itemBuilder: (ctx, i) {
                final n = notifs[i];
                return GestureDetector(
                  onTap: () {
                    if (!n.isRead) {
                      p.markNotificationRead(n.id);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: n.isRead ? C.surface : C.violet.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: n.isRead ? C.border : C.violet.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _getIconColor(n.type).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_getIcon(n.type), color: _getIconColor(n.type), size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(n.title,
                                        style: TextStyle(
                                            color: C.t1,
                                            fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700,
                                            fontSize: 15)),
                                  ),
                                  Text(
                                    DateFormat('MMM d, h:mm a').format(n.timestamp),
                                    style: const TextStyle(color: C.t3, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(n.message, style: const TextStyle(color: C.t2, fontSize: 13, height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return Icons.confirmation_number_rounded;
      case NotificationType.waitlist:
        return Icons.hourglass_top_rounded;
      case NotificationType.reminder:
        return Icons.alarm_rounded;
      case NotificationType.system:
        return Icons.info_outline_rounded;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.booking:
        return C.teal;
      case NotificationType.waitlist:
        return C.amber;
      case NotificationType.reminder:
        return C.rose;
      case NotificationType.system:
        return C.violet;
    }
  }
}
