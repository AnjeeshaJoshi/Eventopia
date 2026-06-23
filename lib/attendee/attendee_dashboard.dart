import 'package:ems_app/attendee/screens/event_browser.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import 'screens/attendee_home.dart';
import 'screens/my_tickets.dart';
import 'screens/attendee_profile.dart';

class AttendeeDashboard extends StatefulWidget {
  const AttendeeDashboard({super.key});

  @override
  State<AttendeeDashboard> createState() => AttendeeDashboardState();
}

class AttendeeDashboardState extends State<AttendeeDashboard> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AttendeeHome(),
      EventBrowser(),
      MyTickets(),
      AttendeeProfile(),
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
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded),
              label: 'Tickets',
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
