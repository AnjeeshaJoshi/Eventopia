import 'package:ems_app/auth/login_screen.dart';
import 'package:ems_app/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'admin/admin_dashboard.dart';
import 'attendee/attendee_dashboard.dart';
import 'auth/app_provider.dart';
import 'organizer/organizer_dashboard.dart';
import 'splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventopia',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/admin': (context) => const AdminDashboard(),
        '/organizer': (context) => const OrganizerDashboard(),
        '/attendee': (context) => const AttendeeDashboard(),
      },
    );
  }
}

// Navigator.push