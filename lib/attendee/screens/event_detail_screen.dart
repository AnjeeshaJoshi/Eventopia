import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/event_provider.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/booking_sheet.dart';
import '../widgets/soldout_sheet.dart';
import '../widgets/event_location_map.dart';
import 'seat_layout_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  Widget _fallbackPoster() => Image.asset(
        'assets/images/cultural.jpg',
        fit: BoxFit.cover,
      );

  String _ticketCategoryLabel(BuildContext context, TicketCategory category) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'ne':
        switch (category) {
          case TicketCategory.vip:
            return 'विशेष';
          case TicketCategory.general:
            return 'सामान्य प्रवेश';
          case TicketCategory.senior:
            return 'ज्येष्ठ नागरिक';
          case TicketCategory.child:
            return 'बालबालिका';
        }
      case 'hi':
        switch (category) {
          case TicketCategory.vip:
            return 'विशेष';
          case TicketCategory.general:
            return 'सामान्य प्रवेश';
          case TicketCategory.senior:
            return 'वरिष्ठ नागरिक';
          case TicketCategory.child:
            return 'बच्चा';
        }
      default:
        return category.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
                  if (event.image != null && event.image!.isNotEmpty)
                    event.image!.startsWith('http')
                        ? Image.network(
                            event.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallbackPoster(),
                          )
                        : Image.asset(
                            event.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallbackPoster(),
                          )
                  else
                    _fallbackPoster(),
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
                      child: Text(
                        l.event.toUpperCase(),
                        style: const TextStyle(color: C.violet, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      isPast ? l.completedUpper.toUpperCase() : (event.status == EventStatus.upcoming ? l.upcoming.toUpperCase() : event.status.name.toUpperCase()),
                      style: TextStyle(
                        color: isPast ? C.t3 : (event.status == EventStatus.upcoming ? C.teal : C.rose),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 300.ms).slideY(begin: .08, end: 0),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: C.t1, height: 1.2),
                ).animate(delay: 80.ms).fadeIn(duration: 350.ms).slideX(begin: -.06, end: 0),
                const SizedBox(height: 20),
                _buildInfoRow(
                  Icons.calendar_month_rounded,
                  DateFormat(
                    'EEEE, MMM d, yyyy',
                    Localizations.localeOf(context).languageCode,
                  ).format(event.date),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time_rounded, '${event.start.format(context)} – ${event.end.format(context)}'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_rounded, event.venue),
                if (event.latitude != null && event.longitude != null) ...[
                  const SizedBox(height: 24),
                  EventLocationMap(event: event)
                      .animate(delay: 160.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: .06, end: 0),
                ],
                const SizedBox(height: 24),
                SectionTitle(title: l.about, action: null),
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
                        Row(
                          children: [
                            const Icon(Icons.local_offer_rounded, color: C.teal, size: 18),
                            const SizedBox(width: 8),
                            Text(l.availablePromoCodes, style: const TextStyle(fontWeight: FontWeight.w700, color: C.teal)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...event.promoCodes.where((p) => p.valid).map((p) => Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                l.useCodeForDiscount(
                                  p.code,
                                  p.discountPct.toStringAsFixed(0),
                                ),
                                style: const TextStyle(fontSize: 13, color: C.teal, fontWeight: FontWeight.w600),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SectionTitle(title: l.tickets, action: null),
                const SizedBox(height: 12),
                ...event.ticketTypes
                    .where((ticket) => ticket.capacity > 0)
                    .map((t) => Container(
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
                                  _ticketCategoryLabel(context, t.category),
                                  style: const TextStyle(color: C.t1, fontWeight: FontWeight.w600, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l.remainingCount((t.capacity - t.sold).toString()),
                                  style: const TextStyle(color: C.t3, fontSize: 12),
                                ),
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
            label: isPast
                ? l.eventEnded
                : event.isSoldOut && event.status == EventStatus.upcoming
                    ? l.joinWaitlist
                    : (event.status == EventStatus.upcoming
                        ? l.bookNow
                        : l.notAvailable),
            onTap: event.isSoldOut && !isPast && event.status == EventStatus.upcoming
                ? () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => SoldOutSheet(event: event),
                    )
                : canBook
                ? () async {
                    try {
                      final eventWithSeats = await context
                          .read<EventProvider>()
                          .ensureSeats(event);
                      if (!context.mounted) return;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeatLayoutScreen(event: eventWithSeats),
                        ),
                      );
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Unable to load seats. Please try again.')),
                      );
                    }
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
