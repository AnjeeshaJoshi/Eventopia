import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/admin/screens/admin_event_requests_screen.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final eventProvider = context.watch<EventProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(body: AppLoadingView());
    }
    final notifs = List<AppNotification>.from(
      bookingProvider.getUserNotifications(authProvider.currentUser!.uid),
    );
    if (authProvider.currentUser!.role == UserRole.admin) {
      for (final event in eventProvider.pendingEvents) {
        notifs.add(
          AppNotification(
            id: 'event-request-${event.eventId}',
            userId: authProvider.currentUser!.uid,
            title: l.eventRequests,
            message: event.title,
            timestamp: event.createdAt,
            type: NotificationType.system,
          ),
        );
      }
      notifs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return Scaffold(
      backgroundColor: C.bg,
      appBar: AppBar(
        title: Text(l.notifications),
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
                  Text(l.noNotificationsYet, style: const TextStyle(color: C.t2, fontSize: 16)),
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
                    if (n.id.startsWith('event-request-')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminEventRequestsScreen(),
                        ),
                      );
                      return;
                    }
                    if (!n.isRead && !n.id.startsWith('event-request-')) {
                      bookingProvider.markNotificationRead(n.id);
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
                                children: [
                                  Expanded(
                                    child: Text(
                                      _localizedTitle(l, n),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: C.t1,
                                            fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700,
                                            fontSize: 15)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'MMM d, h:mm a',
                                      l.localeName,
                                    ).format(n.timestamp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: C.t3, fontSize: 11),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _localizedMessage(l, n),
                                style: const TextStyle(
                                  color: C.t2,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
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

  String _localizedTitle(AppLocalizations l, AppNotification notification) {
    switch (notification.type) {
      case NotificationType.booking:
        return notification.title == 'New Booking'
            ? l.newBooking
            : l.ticketConfirmed;
      case NotificationType.waitlist:
        return notification.title == 'Tickets Available'
            ? l.ticketsAvailable
            : l.onWaitlist;
      case NotificationType.reminder:
        return notification.title;
      case NotificationType.system:
        if (notification.title == 'Event Approved') return l.eventApproved;
        if (notification.title == 'Event Status Updated') {
          return l.eventStatusUpdated;
        }
        return notification.title;
    }
  }

  String _localizedMessage(AppLocalizations l, AppNotification notification) {
    switch (notification.type) {
      case NotificationType.booking:
        if (notification.title == 'New Booking') {
          return _newBookingMessage(l, notification);
        }
        return _bookingEventTitle(notification);
      case NotificationType.waitlist:
        return notification.title == 'Tickets Available'
            ? _waitlistAvailableMessage(notification)
            : _waitlistJoinedMessage(l, notification);
      case NotificationType.reminder:
        return notification.message;
      case NotificationType.system:
        return _systemMessage(l, notification);
    }
  }

  String _newBookingMessage(AppLocalizations l, AppNotification notification) {
    final match = RegExp(
      r'^(.*?)\s+[^\w\s]+\s+(\d+) ticket\(s\)\s+[^\w\s]+\s+(.*)$',
    ).firstMatch(notification.message);
    if (match == null) return notification.message;
    return l.newBookingMessage(
      match.group(1)!,
      int.parse(match.group(2)!),
      match.group(3)!,
    );
  }

  String _systemMessage(AppLocalizations l, AppNotification notification) {
    final title = _eventTitleFromSystemMessage(notification.message);
    if (title == null) return notification.message;
    if (notification.title == 'Event Approved') {
      return l.eventApprovedByAdmin(title);
    }
    if (notification.title == 'Event Status Updated') {
      return l.eventStatusChanged(title, _localizedEventStatus(l, notification.message));
    }
    return notification.message;
  }

  String? _eventTitleFromSystemMessage(String message) {
    final match = RegExp(r'"(.+)"').firstMatch(message);
    return match?.group(1);
  }

  String _localizedEventStatus(AppLocalizations l, String message) {
    final status = RegExp(r' is now ([^.]+)\.$').firstMatch(message)?.group(1);
    switch (status) {
      case 'cancelled':
        return l.cancelled;
      case 'upcoming':
        return l.upcoming;
      default:
        return status ?? '';
    }
  }

  String _bookingEventTitle(AppNotification notification) {
    if (!notification.message.contains(' for ')) return notification.message;
    const marker = ' for ';
    final markerIndex = notification.message.lastIndexOf(marker);
    if (markerIndex == -1) return notification.message;
    return notification.message
        .substring(markerIndex + marker.length)
        .replaceFirst(RegExp(r'\.$'), '');
  }

  String _waitlistAvailableMessage(AppNotification notification) {
    if (!notification.message.contains(' for ')) return notification.message;
    return _bookingEventTitle(notification);
  }

  String _waitlistJoinedMessage(
      AppLocalizations l, AppNotification notification) {
    if (notification.message.startsWith('Position ')) {
      final position = notification.message.substring('Position '.length);
      return '${l.onWaitlist} ${l.waitlistPosition(position)}';
    }
    return l.onWaitlist;
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
