import 'package:ems_app/admin/tabs/checkin_tab.dart';
import 'package:flutter/material.dart';
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

  final pages = const [
    AdminHome(),
    OrganizerManager(),
    EventViewer(),
    CheckInTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Organisers'),
              BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
              BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Check-In'),
            ],
          ),
    );
  }
}