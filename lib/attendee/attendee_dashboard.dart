import 'package:ems_app/attendee/screens/event_browser.dart';
import 'package:flutter/material.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../widgets.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        context.read<BookingProvider>().listenToBookings(userId: user.uid);
        context.read<BookingProvider>().listenToNotifications(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final pages = [
      AttendeeHome(),
      EventBrowser(),
      MyTickets(),
      AttendeeProfile(),
    ];

    return Scaffold(
      floatingActionButton: const LanguageSwitcher(),
      // Keep this away from the app-bar actions, including Sign Out.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: C.violet,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_rounded),
              label: l.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_rounded),
              label: l.explore,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.confirmation_number_rounded),
              label: l.tickets,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded),
              label: l.profile,
            ),
          ],
        ),
      ),
    );
  }
}
