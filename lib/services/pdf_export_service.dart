import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models.dart';

/// Role-safe PDF exports. The attendee report only contains the bookings
/// already returned by that attendee's Firestore query.
class PdfExportService {
  Future<void> shareAttendeeBookingSummary({
    required UserModel attendee,
    required List<BookingModel> bookings,
  }) async {
    final activeBookings =
        bookings.where((booking) => booking.status != BookingStatus.cancelled);
    final totalSpent = activeBookings.fold<double>(
      0,
      (total, booking) => total + booking.total,
    );
    final totalTickets = activeBookings.fold<int>(
      0,
      (total, booking) => total + booking.quantity,
    );
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Eventopia',
                  style: pw.TextStyle(
                    color: PdfColors.deepPurple,
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'MY BOOKING REPORT',
                  style: const pw.TextStyle(color: PdfColors.grey600),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Text(attendee.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text(attendee.email, style: const pw.TextStyle(color: PdfColors.grey700)),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            context: context,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
            data: [
              ['Metric', 'Value'],
              ['Confirmed bookings', '${activeBookings.length}'],
              ['Tickets purchased', '$totalTickets'],
              ['Total spent', 'NPR ${totalSpent.toStringAsFixed(2)}'],
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text('Booking details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            context: context,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
            data: [
              ['Event', 'Type', 'Qty', 'Paid', 'Status'],
              ...bookings.map(
                (booking) => [
                  booking.eventTitle,
                  booking.category.label,
                  '${booking.quantity}',
                  'NPR ${booking.total.toStringAsFixed(2)}',
                  booking.status.name,
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 18),
          pw.Text(
            'Generated on ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename:
          'eventopia_booking_report_${attendee.uid.length >= 8 ? attendee.uid.substring(0, 8) : attendee.uid}.pdf',
    );
  }
}
