import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../widgets/ticket_card.dart';

class MyTickets extends StatelessWidget {
  const MyTickets({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final bookings = p.myBookings;
    
    final upcoming = bookings.where((b) {
      if (b.status == BookingStatus.cancelled) return false;
      final e = p.events.firstWhere((ev) => ev.id == b.eventId);
      return e.status == EventStatus.upcoming;
    }).toList();
    
    final past = bookings.where((b) {
      if (b.status == BookingStatus.cancelled) return false;
      final e = p.events.firstWhere((ev) => ev.id == b.eventId);
      return e.status != EventStatus.upcoming;
    }).toList();

    final cancelled = bookings.where((b) {
      return b.status == BookingStatus.cancelled;
    }).toList();


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Tickets'),
          bottom: const TabBar(

            indicatorColor: C.violet,
            labelColor: C.violet,
            unselectedLabelColor: C.t3,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(upcoming),
            _buildList(past),
            _buildList(cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Booking> list) {
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 64, color: C.t3),
            SizedBox(height: 12),
            Text('No tickets yet.', style: TextStyle(fontSize: 16, color: C.t2)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TicketCard(booking: list[i]),
      ),
    );
  }
}