import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../auth/app_provider.dart';
import '../theme.dart';
import '../widgets.dart';
import 'widgets/create_event_sheet.dart';
import 'widgets/event_detail_sheet.dart';

class OrgHome extends StatelessWidget {
  const OrgHome({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final user = p.current!;
    final myEvents = p.myEvents;

    final totalRevenue = p.bookings
        .where((b) => myEvents.any((e) => e.id == b.eventId))
        .fold<double>(0, (s, b) => s + b.total);

    final totalSold =
    myEvents.fold<int>(0, (s, e) => s + e.bookedSeats);

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
                  p.logout();
                  Navigator.pushReplacementNamed(context, '/login');
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
                        label: 'My Events',
                        value: '${myEvents.length}',
                        icon: Icons.event_rounded,
                        color: C.violet,
                      ),
                      StatBox(
                        label: 'Tickets Sold',
                        value: '$totalSold',
                        icon: Icons.confirmation_number_rounded,
                        color: C.teal,
                      ),
                      StatBox(
                        label: 'Revenue',
                        value:
                        'NPR ${NumberFormat.compact().format(totalRevenue)}',
                        icon: Icons.payments_rounded,
                        color: C.amber,
                      ),
                      StatBox(
                        label: 'Promo Codes',
                        value:
                        '${myEvents.expand((e) => e.promoCodes).length}',
                        icon: Icons.discount_rounded,
                        color: C.rose,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SectionTitle(
                    title: 'My Events',
                    action: '+ Create',
                    onAction: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const CreateEventSheet(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (myEvents.isEmpty)
                    const GCard(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.event_busy_rounded,
                                size: 48, color: C.t3),
                            SizedBox(height: 8),
                            Text('No events yet.',
                                style: TextStyle(color: C.t2)),
                            Text(
                              'Tap "+ Create" to add your first event.',
                              style: TextStyle(fontSize: 12, color: C.t3),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...myEvents.map(
                          (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EventCard(
                          event: e,
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                EventDetailSheet(event: e),
                          ),
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