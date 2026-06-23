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
      backgroundColor: C.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [C.rose, C.amber],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HELP Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          p.logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Good day 👋',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find and book your next event',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Content
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
          ],
        ),
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