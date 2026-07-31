import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'event_detail_screen.dart';
import 'notifications_screen.dart';

class AttendeeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = authProvider.currentUser!;
    final upcoming = eventProvider.events
        .where((e) => e.status == EventStatus.upcoming)
        .toList();
    final myBookings = bookingProvider.getMyBookings(user.uid);
    final activeBookings = myBookings
        .where((booking) => booking.status != BookingStatus.cancelled)
        .toList();
    final unreadNotifications = bookingProvider.unreadNotificationCount(user.uid);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
        SliverAppBar(
        expandedHeight: 140,
        pinned: true,
        backgroundColor: Colors.transparent,
        actions: [
          NotificationBell(
            tooltip: l.notifications,
            unreadCount: unreadNotifications,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          Tooltip(
            message: l.signOut,
            child: IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );

                Future.microtask(() async {
                  try {
                    await authProvider.logout();
                  } catch (e) {
                    // Handle error silently
                  }
                });
              },
            ),
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(gradient: C.gPrimary),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  16,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.organization ?? l.attendee,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      SliverToBoxAdapter(
        child:
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // My stats
                  Row(
                    children: [
                      Expanded(
                        child: StatBox(
                          label: l.myBookings,
                          value: '${activeBookings.length}',
                          icon: Icons.confirmation_number_rounded,
                          color: C.teal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatBox(
                          label: l.totalSpent,
                          value:
                              'NPR ${activeBookings.fold<double>(0, (sum, booking) => sum + booking.total).toStringAsFixed(0)}',
                          icon: Icons.payments_rounded,
                          color: C.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SectionTitle(
                    title: l.upcomingEvents,
                    action: l.seeAll,
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),

                  if (upcoming.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          l.noUpcomingEvents,
                          style: const TextStyle(color: C.t3),
                        ),
                      ),
                    )
                  else
                    ...upcoming.map((e) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: EventCard(
                            event: e,
                            onTap: () => _openBooking(context, e),
                          ),
                        )),

                  const SizedBox(height: 40),
                ],
              ),
            ),
      ),
          ],
        ),
    );
  }

  void _openBooking(BuildContext context, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
    );
  }
}
