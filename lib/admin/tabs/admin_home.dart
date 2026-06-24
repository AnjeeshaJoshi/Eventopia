import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth/app_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../widgets/qr_scan_dialog.dart';
import '../widgets/quick_action.dart';
import '../widgets/register_org_sheet.dart';
import 'admin_reports.dart';
import '../../models.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final user = p.current;
    final orgCount = p.organizers.length;
    final attCount = p.attendeeUsers.length;
    final evtCount = p.events.length;
    final totalRevenue = p.bookings.fold<double>(0, (s, b) => s + b.total);

    if (user == null) {
      return const Center(
        child: Text('No user logged in'),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: C.violet,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 2,
            scrolledUnderElevation: 2,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: C.gPrimary,
                ),
                padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(.25),
                        ),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Administrator',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                              (route) => false,
                        );

                        Future.microtask(() {
                          p.logout();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── MAIN CONTENT ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats grid ────────────────────────────────────
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                  children: [
                    StatBox(
                      label: 'Organisers',
                      value: '$orgCount',
                      icon: Icons.business_rounded,
                      color: C.org,
                    ),
                    StatBox(
                      label: 'Attendees',
                      value: '$attCount',
                      icon: Icons.people_rounded,
                      color: C.attendee,
                    ),
                    StatBox(
                      label: 'Events',
                      value: '$evtCount',
                      icon: Icons.event_rounded,
                      color: C.violet,
                    ),
                    StatBox(
                      label: 'Revenue',
                      value:
                          'NPR ${NumberFormat.compact().format(totalRevenue)}',
                      icon: Icons.payments_rounded,
                      color: C.amber,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Quick actions ───────────────────────────────
                const SectionTitle(title: 'Quick Actions'),
                const SizedBox(height: 12),

                Row(
                  children: [
                    QuickAction(
                      icon: Icons.person_add_rounded,
                      label: 'Add\nOrganiser',
                      color: C.org,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const RegisterOrgSheet(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    QuickAction(
                      icon: Icons.qr_code_scanner_rounded,
                      label: 'Scan\nQR',
                      color: C.teal,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => QRScanDialog(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    QuickAction(
                      icon: Icons.bar_chart_rounded,
                      label: 'Reports',
                      color: C.sky,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminReports()),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Events ───────────────────────────────────────
                SectionTitle(
                  title: 'All Events',
                  action: 'See all',
                  onAction: () {},
                ),
                const SizedBox(height: 12),

                ...p.events.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EventCard(
                      event: e,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => _StatusChangeSheet(event: e),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Occupancy ────────────────────────────────────
                const SectionTitle(title: 'Auditorium Occupancy'),
                const SizedBox(height: 12),

                GCard(
                  child: Column(
                    children: p.events.map((e) {
                      final pct = e.occupancyRate;
                      final col = pct > .8
                          ? C.rose
                          : pct > .5
                              ? C.amber
                              : C.teal;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    e.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${(pct * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: col,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor: C.surface,
                                valueColor: AlwaysStoppedAnimation(col),
                                minHeight: 7,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${e.bookedSeats} / ${e.totalSeats} seats booked',
                              style: const TextStyle(
                                fontSize: 11,
                                color: C.t3,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChangeSheet extends StatefulWidget {
  final AppEvent event;

  const _StatusChangeSheet({required this.event});

  @override
  State<_StatusChangeSheet> createState() => _StatusChangeSheetState();
}

class _StatusChangeSheetState extends State<_StatusChangeSheet> {
  late EventStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.event.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const Text('Change Event Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...EventStatus.values.map((s) {
            return RadioListTile<EventStatus>(
              title: Text(s.label),
              value: s,
              groupValue: _status,
              activeColor: C.violet,
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            );
          }),
          const SizedBox(height: 20),
          GBtn(
            label: 'Save Changes',
            onTap: () {
              context.read<AppProvider>().updateEventStatus(widget.event.id, _status);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
