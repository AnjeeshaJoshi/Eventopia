import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/booking_sheet.dart';
import 'seat_layout_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final AppEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = event.date.isBefore(DateTime(now.year, now.month, now.day));
    final canBook = event.status == EventStatus.upcoming && !isPast;

    return Scaffold(
      backgroundColor: C.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: C.bg,
            iconTheme: const IconThemeData(color: C.t1),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Show poster image if available, else show placeholder
                  if (event.posterPath != null)
                    event.posterPath!.startsWith('assets/')
                        ? Image.asset(
                            event.posterPath!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: C.violet.withOpacity(0.1),
                              child: Center(
                                child: Icon(Icons.event_seat_rounded,
                                    size: 64, color: C.violet.withOpacity(0.2)),
                              ),
                            ),
                          )
                        : Image.file(
                            File(event.posterPath!),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: C.violet.withOpacity(0.1),
                              child: Center(
                                child: Icon(Icons.event_seat_rounded,
                                    size: 64, color: C.violet.withOpacity(0.2)),
                              ),
                            ),
                          )
                  else
                    Container(
                      color: C.violet.withOpacity(0.1),
                      child: Center(
                        child: Icon(Icons.event_seat_rounded,
                            size: 64, color: C.violet.withOpacity(0.2)),
                      ),
                    ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, C.bg],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: C.violet.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: C.violet.withOpacity(0.3)),
                      ),
                      child: const Text(
                        'EVENT',
                        style: TextStyle(color: C.violet, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isPast ? 'COMPLETED' : (event.status == EventStatus.upcoming ? 'UPCOMING' : event.status.name.toUpperCase()),
                      style: TextStyle(
                        color: isPast ? C.t3 : (event.status == EventStatus.upcoming ? C.teal : C.rose),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: C.t1, height: 1.2),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.calendar_month_rounded, DateFormat('EEEE, MMM d, yyyy').format(event.date)),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time_rounded, DateFormat('h:mm a').format(event.date)),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_rounded, event.location),
                const SizedBox(height: 24),
                const SectionTitle(title: 'About', action: null),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: const TextStyle(color: C.t2, fontSize: 14, height: 1.6),
                ),
                if (event.promoCodes.any((p) => p.valid)) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: C.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: C.teal.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.local_offer_rounded, color: C.teal, size: 18),
                            SizedBox(width: 8),
                            Text('Available Promo Codes', style: TextStyle(fontWeight: FontWeight.w700, color: C.teal)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...event.promoCodes.where((p) => p.valid).map((p) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Use code ${p.code} for ${p.discountPct.toStringAsFixed(0)}% off!',
                                style: const TextStyle(fontSize: 13, color: C.teal, fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const SectionTitle(title: 'Tickets', action: null),
                const SizedBox(height: 12),
                ...event.ticketTypes.map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: C.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.category.label,
                                  style: const TextStyle(color: C.t1, fontWeight: FontWeight.w600, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text('${t.capacity - t.sold} remaining', style: const TextStyle(color: C.t3, fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text('NPR ${t.price.toStringAsFixed(0)}', style: const TextStyle(color: C.violet, fontWeight: FontWeight.w700, fontSize: 18)),
                        ],
                      ),
                    )),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: SizedBox(
          width: double.infinity,
          child: GBtn(
            label: isPast ? 'Event Ended' : (event.status == EventStatus.upcoming ? 'Book Now' : 'Not Available'),
            onTap: canBook
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeatLayoutScreen(event: event),
                      ),
                    );
                  }
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: C.violet.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: C.violet, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: const TextStyle(color: C.t1, fontSize: 15, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}
