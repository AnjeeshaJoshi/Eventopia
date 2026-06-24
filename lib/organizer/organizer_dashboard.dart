import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/app_provider.dart';
import '../theme.dart';
import 'org_analytics.dart';
import 'org_events.dart';
import 'org_home.dart';
import 'org_profile.dart';

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  State<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<AppProvider>(context, listen: false);
      if (p.current?.mustChangePassword == true) {
        setState(() => _tab = 3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const OrgHome(),
      const OrgEvents(),
      const OrgAnalytics(),
      const OrgProfile(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: pages,
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: C.border),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_rounded),
              label: 'My Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}