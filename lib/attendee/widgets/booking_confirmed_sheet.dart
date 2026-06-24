import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class BookingConfirmedSheet extends StatelessWidget {
  final Booking booking;

  const BookingConfirmedSheet({super.key, required this.booking});

  Future<void> _downloadPdf(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('Eventopia Ticket', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 20),
                  pw.Text('Event: ${booking.eventTitle}', style: const pw.TextStyle(fontSize: 18)),
                  pw.SizedBox(height: 10),
                  pw.Text('Category: ${booking.category.label}'),
                  pw.Text('Quantity: ${booking.quantity}'),
                  pw.Text('Section: ${booking.category.section}'),
                  pw.Text('Total Paid: NPR ${booking.total.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 20),
                  pw.Text('Ref: ${booking.id.substring(0, 8).toUpperCase()}'),
                  pw.SizedBox(height: 20),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: booking.qrData,
                    width: 150,
                    height: 150,
                  ),
                ],
              ),
            );
          },
        ),
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ticket_${booking.id.substring(0, 8)}.pdf');
      await file.writeAsBytes(await pdf.save());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket saved to ${file.path}'),
            action: SnackBarAction(
              label: 'Print/Share',
              onPressed: () {
                Printing.sharePdf(bytes: file.readAsBytesSync(), filename: 'ticket.pdf');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate PDF')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: .85,
      maxChildSize: .95,
      minChildSize: .5,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: ListView(
          controller: sc,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: C.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

// Success badge
            Center(
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: C.teal.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded,
                        color: C.teal, size: 42),
                  ),
                  const SizedBox(height: 12),
                  const Text('Booking Confirmed!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const Text('Show QR code at entry',
                      style: TextStyle(fontSize: 13, color: C.t2)),
                ],
              ),
            ),

            const SizedBox(height: 24),

// QR code
            Center(
              child: Container(
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: booking.qrData,
                  version: QrVersions.auto,
                ),
              ),
            ),

            const SizedBox(height: 20),

// Booking details card
            GCard(
              child: Column(
                children: [
                  InfoRow(
                      icon: Icons.event_rounded,
                      label: 'Event',
                      value: booking.eventTitle),
                  InfoRow(
                      icon: Icons.confirmation_number_rounded,
                      label: 'Ticket',
                      value: '${booking.category.label} × ${booking.quantity}'),
                  InfoRow(
                      icon: Icons.event_seat_rounded,
                      label: 'Section',
                      value: booking.category.section),
                  if (booking.discount > 0)
                    InfoRow(
                        icon: Icons.discount_rounded,
                        label: 'Discount',
                        value: '- NPR ${booking.discount.toStringAsFixed(2)}'),
                  InfoRow(
                      icon: Icons.payments_rounded,
                      label: 'Total Paid',
                      value: 'NPR ${booking.total.toStringAsFixed(2)}'),
                  InfoRow(
                      icon: Icons.tag_rounded,
                      label: 'Ref',
                      value: booking.id.substring(0, 8).toUpperCase()),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GBtn(
                    label: 'Download PDF',
                    onTap: () => _downloadPdf(context),
                    icon: Icons.download_rounded,
                    gradient: LinearGradient(colors: [C.sky, C.indigo]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GBtn(
                    label: 'Done',
                    onTap: () => Navigator.pop(context),
                    gradient: C.gTeal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
