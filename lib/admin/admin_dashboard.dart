import 'package:ems_app/admin/tabs/admin_profile.dart';
import 'package:ems_app/admin/tabs/checkin_tab.dart';
import 'package:flutter/material.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/user_provider.dart';
import '../models.dart';
import '../widgets.dart';
import '../theme.dart';
import 'tabs/admin_home.dart';
import 'tabs/organizer_manager.dart';
import 'tabs/event_viewer.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _tab = 0;
  bool _loadedAdminData = false;

  final pages = [
    const AdminHome(),
    const OrganizerManager(),
    const EventViewer(),
    AdminProfile(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthProvider>().currentUser;
    if (!_loadedAdminData && user?.role == UserRole.admin) {
      _loadedAdminData = true;
      context.read<UserProvider>().fetchUsers();
      context.read<BookingProvider>().fetchBookings();
      context.read<BookingProvider>().listenToBookings();
      context.read<BookingProvider>().listenToNotifications(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: const LanguageSwitcher(),
      // Keep this away from the app-bar actions, including Sign Out.
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: pages[_tab],
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: l.home),
          BottomNavigationBarItem(icon: const Icon(Icons.people), label: l.users),
          BottomNavigationBarItem(icon: const Icon(Icons.event), label: l.events),
          BottomNavigationBarItem(icon: const Icon(Icons.person), label: l.profile),
        ],
      ),
    );
  }
}
