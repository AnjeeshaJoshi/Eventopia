import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'widgets/create_event_sheet.dart';
import 'widgets/event_detail_sheet.dart';
import 'qr_scanner_screen.dart';
import '../attendee/screens/notifications_screen.dart';

class OrgHome extends StatelessWidget {
  const OrgHome({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final bookingProvider = context.watch<BookingProvider>();

    if (authProvider.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final user = authProvider.currentUser!;
    final myEvents = eventProvider.getMyEvents(user.uid);
    final unreadNotifications = bookingProvider.unreadNotificationCount(user.uid);

    // Ticket inventory is updated atomically when a booking is made and the
    // event stream is already active for organizers. Deriving revenue here
    // keeps this number live without requiring access to every booking.
    final totalRevenue = myEvents
        .expand((event) => event.ticketTypes)
        .fold<double>(0, (sum, ticket) => sum + ticket.sold * ticket.price);

    final totalSold =
    myEvents.fold<int>(0, (s, e) => s + e.bookedSeats);

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
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                ),
              ),
              Tooltip(
                message: l.scanTicket,
                child: Semantics(
                  label: l.scanTicket,
                  child: IconButton(
                    icon: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (myEvents.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l.noEventsYet),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QrScannerScreen(
                            event: myEvents.first,
                            organizerId: user.uid,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Tooltip(
                message: l.signOut,
                child: Semantics(
                  label: l.signOut,
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
                        } catch(e) {
                          // Handle error silently or log
                        }
                      });
                    },
                  ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.business_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.organization ?? 'Organiser',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                100,
              ),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      StatBox(
                        label: l.myEvents,
                        value: '${myEvents.length}',
                        icon: Icons.event_rounded,
                        color: C.violet,
                      ),
                      StatBox(
                        label: l.ticketsSold,
                        value: '$totalSold',
                        icon: Icons.confirmation_number_rounded,
                        color: C.teal,
                      ),
                      StatBox(
                        label: l.revenue,
                        value:
                        'NPR ${NumberFormat.compact().format(totalRevenue)}',
                        icon: Icons.payments_rounded,
                        color: C.amber,
                      ),
                      StatBox(
                        label: l.promoCodes,
                        value:
                        '${myEvents.expand((e) => e.promoCodes).length}',
                        icon: Icons.discount_rounded,
                        color: C.rose,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SectionTitle(
                    title: l.myEvents,
                    action: l.createEvent,
                    onAction: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CreateEventSheet(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (myEvents.isEmpty)
                    GCard(
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.event_busy_rounded,
                                size: 48, color: C.t3),
                            const SizedBox(height: 8),
                            Text(l.noEventsYet,
                                style: const TextStyle(color: C.t2)),
                            Text(
                              l.tapCreateToAddFirstEvent,
                              style: const TextStyle(fontSize: 12, color: C.t3),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...myEvents.map(
                          (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            EventCard(
                              event: e,
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) =>
                                    EventDetailSheet(event: e),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                gradient: C.gPrimary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.qr_code_scanner),
                                label: Text(l.scanTicket),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QrScannerScreen(
                                        event: e,
                                        organizerId: user.uid,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
