import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../widgets.dart';
import '../theme.dart';
import '../providers/booking_provider.dart';
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      if (user != null) {
        context.read<BookingProvider>().listenToNotifications(user.uid);
      }
      if (authProvider.currentUser?.mustChangePassword == true) {
        setState(() => _tab = 3);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final mustChangePassword =
        context.watch<AuthProvider>().currentUser?.mustChangePassword == true;

    // A temporary admin-issued password grants access only to the password
    // change screen. Once AuthProvider updates Firestore, this rebuilds into
    // the normal organizer dashboard automatically.
    if (mustChangePassword) {
      return const Scaffold(body: OrgProfile());
    }
    return Scaffold(
      floatingActionButton: const LanguageSwitcher(),
      // Keep this away from the app-bar actions, including Sign Out.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // Defer analytics and secondary tabs until the organizer opens them.
      body: switch (_tab) {
        0 => const OrgHome(),
        1 => const OrgEvents(),
        2 => const OrgAnalytics(),
        _ => const OrgProfile(),
      },

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
              icon: const Icon(Icons.dashboard_rounded),
              label: l.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.event_rounded),
              label: l.myEvents,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: l.analytics,
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
