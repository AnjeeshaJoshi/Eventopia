import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import 'package:ems_app/providers/event_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});

  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  String? _selectedEventId;

  Future<void> _downloadReportPdf(EventModel event, Map<TicketCategory, int> byCategory, double totalRevenue, AppLocalizations l) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Eventopia Analytics', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple)),
                    pw.Text('REPORT', style: pw.TextStyle(fontSize: 24, color: PdfColors.grey500)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Event Details', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple)),
                    pw.SizedBox(height: 10),
                    pw.Text('Name: ${event.title}', style: const pw.TextStyle(fontSize: 14)),
                    pw.Text('Date: ${DateFormat('MMMM dd, yyyy').format(event.date)}', style: const pw.TextStyle(fontSize: 14)),
                    pw.Text('Organizer: ${event.organizerName}', style: const pw.TextStyle(fontSize: 14)),
                    pw.Text('Location: ${event.venue}', style: const pw.TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Text('Key Performance Indicators', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                border: null,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                },
                data: [
                  ['Metric', 'Value'],
                  ['Total Tickets Sold', '${event.bookedSeats} / ${event.totalSeats}'],
                  ['Total Revenue', 'NPR ${NumberFormat.compact().format(totalRevenue)}'],
                  ['Occupancy Rate', '${(event.occupancyRate * 100).toStringAsFixed(1)}%'],
                  ['Available Seats', '${event.availableSeats}'],
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text('Sales by Ticket Category', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.deepPurple)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                border: null,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.deepPurple300),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                },
                data: [
                  ['Category', 'Tickets Sold'],
                  ...TicketCategory.values.where((c) => (byCategory[c] ?? 0) > 0).map((cat) {
                    final sold = byCategory[cat] ?? 0;
                    return [cat.label, '$sold'];
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 40),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text('Generated on ${DateFormat('MMMM dd, yyyy').format(DateTime.now())} by Eventopia System', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
              ),
            ];
          },
        ),
      );

      final bytes = await pdf.save();
      await Printing.sharePdf(bytes: bytes, filename: 'report_${event.eventId.length >= 8 ? event.eventId.substring(0, 8) : event.eventId}.pdf');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedToGeneratePdf(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final allEvents = eventProvider.events;
    final l = AppLocalizations.of(context)!;

    if (allEvents.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.reportsAndAnalytics)),
        body: Center(
          child: Text(
            l.noEventsToShowAnalytics,
            style: const TextStyle(color: C.t2),
          ),
        ),
      );
    }

    // Default to the first event if none selected
    if (_selectedEventId == null || !allEvents.any((e) => e.eventId == _selectedEventId)) {
      _selectedEventId = allEvents.first.eventId;
    }

    final data = eventProvider.analytics(_selectedEventId!);
    final event = data['event'] as EventModel;
    final daily = (data['daily'] as List<DailySales>);
    final byCategory = data['byCategory'] as Map<TicketCategory, int>;

    final totalRevenue = (data['totalRevenue'] as num?)?.toDouble() ?? 0.0;

    final maxRevenue = daily.isEmpty
        ? 0.0
        : daily.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.reportsAndAnalytics),
        actions: [
          Tooltip(
            message: l.downloadPdfReport,
            child: Semantics(
              button: true,
              label: l.downloadPdfReport,
              child: IconButton(
                icon: const Icon(Icons.download_rounded),
                onPressed: () => _downloadReportPdf(event, byCategory, totalRevenue, l),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            // Event selector
            DropdownButtonFormField<String>(
              value: _selectedEventId,
              dropdownColor: C.card,
              decoration: InputDecoration(
                labelText: l.selectEvent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.border),
                ),
              ),
              isExpanded: true,
              items: allEvents.map((e) {
                return DropdownMenuItem(
                  value: e.eventId,
                  child: Text(e.title, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedEventId = v);
              },
            ),

            const SizedBox(height: 16),

            // KPI Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatBox(
                  label: l.ticketsSold,
                  value: '${event.bookedSeats}',
                  icon: Icons.confirmation_number_rounded,
                  color: C.teal,
                  sub: l.ofTotalSeats(event.totalSeats.toString()),
                ),
                StatBox(
                  label: l.revenue,
                  value: 'NPR ${NumberFormat.compact().format(totalRevenue)}',
                  icon: Icons.payments_rounded,
                  color: C.amber,
                ),
                StatBox(
                  label: l.occupancy,
                  value: '${(event.occupancyRate * 100).toStringAsFixed(0)}%',
                  icon: Icons.event_seat_rounded,
                  color: event.occupancyRate > .8 ? C.rose : C.violet,
                ),
                StatBox(
                  label: l.available,
                  value: '${event.availableSeats}',
                  icon: Icons.chair_rounded,
                  color: C.sky,
                ),
              ],
            ),

            const SizedBox(height: 20),

            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.sevenDayRevenue,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 160,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (daily.isEmpty)
                            ? 10
                            : (maxRevenue <= 0 ? 10 : maxRevenue * 1.3),
                        barGroups: daily.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.revenue,
                                gradient: C.gPrimary,
                                width: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 44,
                              getTitlesWidget: (v, _) => Text(
                                NumberFormat.compact().format(v),
                                style: const TextStyle(fontSize: 10, color: C.t3),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                final i = v.toInt();
                                if (i < 0 || i >= daily.length) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  DateFormat('dd/M').format(daily[i].date),
                                  style: const TextStyle(fontSize: 9, color: C.t3),
                                );
                              },
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (_) =>
                              const FlLine(color: C.border, strokeWidth: 1),
                        ),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Category Sales
            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.salesByCategory,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...TicketCategory.values.map((cat) {
                    final sold = byCategory[cat] ?? 0;
                    final ticketType = event.ticketTypes
                        .where((t) => t.category == cat)
                        .firstOrNull;

                    if (ticketType == null) return const SizedBox.shrink();

                    final pct = ticketType.capacity == 0
                        ? 0.0
                        : (sold / ticketType.capacity).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(
                              cat.label,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: C.t2),
                            ),
                          ),
                          Expanded(
                            child: Semantics(
                              label: l.categorySalesProgress(cat.label, sold.toString()),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: C.surface,
                                  valueColor: AlwaysStoppedAnimation(cat.color),
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$sold',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cat.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
