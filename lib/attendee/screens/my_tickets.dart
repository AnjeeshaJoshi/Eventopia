import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/event_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:ems_app/services/pdf_export_service.dart';
import '../../models.dart';
import '../../theme.dart';
import '../widgets/ticket_card.dart';

class MyTickets extends StatelessWidget {
  const MyTickets({super.key});

  Future<void> _downloadBookingReport(
    BuildContext context,
    UserModel attendee,
    List<BookingModel> bookings,
  ) async {
    try {
      await PdfExportService().shareAttendeeBookingSummary(
        attendee: attendee,
        bookings: bookings,
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToGeneratePdf(error.toString()),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final bookings = bookingProvider.getMyBookings(authProvider.currentUser!.uid);
    
    final upcoming = bookings.where((b) {
      if (b.status == BookingStatus.cancelled) return false;
      final e = eventProvider.events.where((ev) => ev.eventId == b.eventId).firstOrNull;
      return e != null && e.status == EventStatus.upcoming;
    }).toList();
    
    final past = bookings.where((b) {
      if (b.status == BookingStatus.cancelled) return false;
      final e = eventProvider.events.where((ev) => ev.eventId == b.eventId).firstOrNull;
      return e == null || e.status != EventStatus.upcoming;
    }).toList();

    final cancelled = bookings.where((b) {
      return b.status == BookingStatus.cancelled;
    }).toList();


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.myTickets),
          actions: [
            IconButton(
              tooltip: l.downloadPdfReport,
              icon: const Icon(Icons.download_rounded),
              onPressed: () => _downloadBookingReport(
                context,
                authProvider.currentUser!,
                bookings,
              ),
            ),
          ],
          bottom: TabBar(

            indicatorColor: C.violet,
            labelColor: C.violet,
            unselectedLabelColor: C.t3,
            tabs: [
              Tab(text: l.upcoming),
              Tab(text: l.past),
              Tab(text: l.cancelled),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(l, upcoming),
            _buildList(l, past),
            _buildList(l, cancelled),
          ],
        ),
      ),
    );
  }

  Widget _buildList(AppLocalizations l, List<BookingModel> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.confirmation_number_outlined, size: 64, color: C.t3),
            const SizedBox(height: 12),
            Text(l.noTicketsYet, style: const TextStyle(fontSize: 16, color: C.t2)),
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
