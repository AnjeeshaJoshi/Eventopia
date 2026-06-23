import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../auth/app_provider.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets.dart';

class OrgAnalytics extends StatefulWidget {
  const OrgAnalytics({super.key});

  @override
  State<OrgAnalytics> createState() => _OrgAnalyticsState();
}

class _OrgAnalyticsState extends State<OrgAnalytics> {
  String? _selectedEventId;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final myEvents = p.myEvents;

    if (myEvents.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Analytics')),
        body: const Center(
          child: Text(
            'Create events to see analytics.',
            style: TextStyle(color: C.t2),
          ),
        ),
      );
    }

    _selectedEventId ??= myEvents.first.id;

    final data = p.analytics(_selectedEventId!);
    final event = data['event'] as AppEvent;
    final daily = (data['daily'] as List<DailySales>);
    final byCategory = data['byCategory'] as Map<TicketCategory, int>;

    final totalRevenue = data['totalRevenue'] ?? 0;

    final maxRevenue = daily.isEmpty
        ? 0.0
        : daily.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),

      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            100,
          ),

          children: [
            //event selector
            DropdownButtonFormField<String>(
              value: _selectedEventId,
              dropdownColor: C.card,
              decoration: InputDecoration(
                labelText: 'Select Event',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: C.border),
                ),
              ),
              items: myEvents.map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.title, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedEventId = v);
              },
            ),

            const SizedBox(height: 16),

            // kpi grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatBox(
                  label: 'Tickets Sold',
                  value: '${event.bookedSeats}',
                  icon: Icons.confirmation_number_rounded,
                  color: C.teal,
                  sub: 'of ${event.totalSeats} total',
                ),
                StatBox(
                  label: 'Revenue',
                  value: 'NPR ${NumberFormat.compact().format(totalRevenue)}',
                  icon: Icons.payments_rounded,
                  color: C.amber,
                ),
                StatBox(
                  label: 'Occupancy',
                  value: '${(event.occupancyRate * 100).toStringAsFixed(0)}%',
                  icon: Icons.event_seat_rounded,
                  color: event.occupancyRate > .8 ? C.rose : C.violet,
                ),
                StatBox(
                  label: 'Available',
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
                  const Text(
                    '7-Day Revenue',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

           //category
            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales by Category',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: C.surface,
                                valueColor:
                                AlwaysStoppedAnimation(cat.color),
                                minHeight: 8,
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