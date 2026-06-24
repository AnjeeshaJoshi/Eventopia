import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'event_detail_screen.dart';

class AttendeeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    if (p.current == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final user = p.current!;
    final upcoming = p.events
        .where((e) => e.status == EventStatus.upcoming)
        .take(3)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
        SliverAppBar(
        expandedHeight: 130,
        pinned: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
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

              Future.microtask(() {
                p.logout();
              });
            },
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  C.rose,
                  C.amber,
                ],
              ),
            ),
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
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
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

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.organization ?? 'Attendee',
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
                            const SizedBox(height: 1),
                            Text(
                              'Discover. Connect. Celebrate.',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                              ),
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
                          label: 'My Bookings',
                          value: '${p.myBookings.length}',
                          icon: Icons.confirmation_number_rounded,
                          color: C.teal,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatBox(
                          label: 'Total Spent',
                          value:
                              'NPR ${p.myBookings.fold<double>(0, (s, b) => s + b.total).toStringAsFixed(0)}',
                          icon: Icons.payments_rounded,
                          color: C.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  SectionTitle(
                    title: 'Upcoming Events',
                    action: 'See all',
                    onAction: () {},
                  ),
                  const SizedBox(height: 16),

                  if (upcoming.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'No upcoming events.',
                          style: TextStyle(color: C.t3),
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

  void _openBooking(BuildContext context, AppEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)),
    );
  }
}