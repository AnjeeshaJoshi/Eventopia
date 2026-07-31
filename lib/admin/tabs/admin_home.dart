import 'package:ems_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/user_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/quick_action.dart';
import '../screens/admin_event_requests_screen.dart';
import '../widgets/register_org_sheet.dart';
import '../widgets/admin_event_action_sheet.dart';
import 'admin_reports.dart';
import '../../models.dart';
import '../../attendee/screens/notifications_screen.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final eventProvider = context.watch<EventProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    
    final l = AppLocalizations.of(context)!;
    
    final user = authProvider.currentUser;
    final orgCount = userProvider.organizers.length;
    final attCount = userProvider.attendeeUsers.length;
    final evtCount = eventProvider.events.length;
    final totalRevenue = bookingProvider.bookings
        .where((booking) =>
            booking.status == BookingStatus.confirmed ||
            booking.status == BookingStatus.checkedIn)
        .fold<double>(0, (sum, booking) => sum + booking.total);

    if (user == null) {
      return Center(
        child: Text(l.noUserLoggedIn),
      );
    }
    final unreadNotifications =
        bookingProvider.unreadNotificationCount(user.uid) + eventProvider.pendingEvents.length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar
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
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: () async {
                    try {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: C.gPrimary,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l.administrator,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
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

          // MAIN CONTENT
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    StatBox(
                      label: l.organisers,
                      value: '$orgCount',
                      icon: Icons.business_rounded,
                      color: C.org,
                    ),
                    StatBox(
                      label: l.attendees,
                      value: '$attCount',
                      icon: Icons.people_rounded,
                      color: C.attendee,
                    ),
                    StatBox(
                      label: l.events,
                      value: '$evtCount',
                      icon: Icons.event_rounded,
                      color: C.violet,
                    ),
                    StatBox(
                      label: l.revenue,
                      value: 'NPR ${NumberFormat.compact().format(totalRevenue)}',
                      icon: Icons.payments_rounded,
                      color: C.amber,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick actions
                SectionTitle(title: l.quickActions),
                const SizedBox(height: 12),

                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    QuickAction(
                      icon: Icons.person_add_rounded,
                      label: l.addOrganiser,
                      color: C.org,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const RegisterOrgSheet(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    QuickAction(
                      icon: Icons.assignment_late_rounded,
                      label: l.eventRequests,
                      color: C.amber,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AdminEventRequestsScreen()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    QuickAction(
                      icon: Icons.bar_chart_rounded,
                      label: l.reports,
                      color: C.sky,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminReports()),
                        );
                      },
                    ),
                  ],
                ),
                ),

                const SizedBox(height: 24),

                // Events
                SectionTitle(
                  title: l.allEvents,
                  action: l.seeAll,
                  onAction: () {},
                ),
                const SizedBox(height: 12),

                ...eventProvider.events.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: e,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AdminEventActionSheet(event: e),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //Occupancy
                SectionTitle(title: l.auditoriumOccupancy),
                const SizedBox(height: 12),

                GCard(
                  child: Column(
                    children: eventProvider.events.map((e) {
                      final pct = e.occupancyRate;
                      final col = pct > .8
                          ? C.rose
                          : pct > .5
                              ? C.amber
                              : C.teal;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${(pct * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: col,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Semantics(
                              label: l.occupancyProgress(e.title, (pct * 100).toStringAsFixed(0)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: C.surface,
                                  valueColor: AlwaysStoppedAnimation(col),
                                  minHeight: 7,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              l.seatsBooked(e.bookedSeats.toString(), e.totalSeats.toString()),
                              style: const TextStyle(
                                fontSize: 11,
                                color: C.t3,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
