import 'package:ems_app/auth/login_screen.dart';
import 'package:ems_app/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'firebase_options.dart';

import 'admin/admin_dashboard.dart';
import 'attendee/attendee_dashboard.dart';
// import 'auth/app_provider.dart'; // We are replacing this
import 'organizer/organizer_dashboard.dart';
import 'splash_screen.dart';
import 'theme.dart';

import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/user_provider.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eventopia',
          theme: AppTheme.light,
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ne'),
            Locale('hi'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
      },
    );
  }
}
