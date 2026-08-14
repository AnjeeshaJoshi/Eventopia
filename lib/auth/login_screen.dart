import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../admin/tabs/changepassword_screen.dart';
import '../theme.dart';
import '../widgets.dart';
import 'register_screen.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/providers/user_provider.dart';
import '../utils/error_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pwd = TextEditingController();
  bool _hidePwd = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _pwd.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    final l = AppLocalizations.of(context)!;

    if (!_form.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final didAuthenticate = await authProvider.login(
        _email.text.trim(),
        _pwd.text,
      );

      if (!mounted) return;

      setState(() => _loading = false);

      if (!didAuthenticate) {
        setState(() => _error = authProvider.error ?? l.invalidEmail);
        return;
      }
      final user = authProvider.currentUser!;

      // Start role-specific streams before changing routes. This means the
      // first dashboard frame can render with data already on its way instead
      // of waiting for its post-frame callback.
      _primeDashboardData(user);

      if (user.role == UserRole.organizer && user.mustChangePassword) {
        Navigator.pushReplacementNamed(context, '/organizer');
        if (mounted) {
          final l = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.changeDefaultPasswordPrompt),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        _navigate(user.role);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = ErrorHandler.getErrorMessage(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: const LanguageSwitcher(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Container(
        color: const Color(0xFFF8FAFC),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/images/mike.png',
                              width: 70,
                              fit: BoxFit.contain,
                            ),
                          ),

                          Semantics(
                            header: true,
                            child: Text(
                              l.appTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            l.welcomeBack,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            l.loginToContinue,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Form ─────────────────────────────────────────────────
                          GCard(
                            padding: const EdgeInsets.all(18),
                            borderColor: Colors.transparent,
                            child: Form(
                              key: _form,
                              child: Column(
                                children: [
                                  AppField(
                                    label: l.emailAddress,
                                    controller: _email,
                                    keyboard: TextInputType.emailAddress,
                                    prefix: Icons.email_outlined,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? l.emailIsRequired
                                            : RegExp(
                                                        r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                                    .hasMatch(v.trim())
                                                ? null
                                                : l.enterValidEmail,
                                  ),
                                  const SizedBox(height: 14),
                                  AppField(
                                    label: l.password,
                                    controller: _pwd,
                                    obscure: _hidePwd,
                                    prefix: Icons.lock_outline_rounded,
                                    suffix: IconButton(
                                      tooltip: l.password,
                                      icon: Icon(
                                        _hidePwd
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        size: 18,
                                        color: C.t3,
                                      ),
                                      onPressed: () =>
                                          setState(() => _hidePwd = !_hidePwd),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return l.passwordIsRequired;
                                      }
                                      if (v.length < 6) return l.minimumSixChars;
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ChangePasswordScreen(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        l.forgotPassword,
                                        style: const TextStyle(
                                          color: Color(0xFFEC4899),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_error != null) ErrorBanner(_error!),

                                  const SizedBox(height: 18),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                                    child: Semantics(
                                      button: true,
                                      label: l.logIn,
                                      child: GBtn(
                                        label: l.logIn,
                                        onTap: _login,
                                        loading: _loading,
                                        icon: Icons.login_rounded,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: .2),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 15,
                                ),
                                children: [
                                  TextSpan(text: l.dontHaveAccount),
                                  TextSpan(
                                    text: l.createAccountTitle,
                                    style: const TextStyle(
                                      color: Color(0xFFEC4899),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _navigate(UserRole role) {
    final route = switch (role) {
      UserRole.admin => '/admin',
      UserRole.organizer => '/organizer',
      UserRole.attendee => '/attendee',
    };

    Navigator.pushReplacementNamed(context, route);
  }

  void _primeDashboardData(UserModel user) {
    final bookings = context.read<BookingProvider>();
    switch (user.role) {
      case UserRole.attendee:
        bookings.listenToBookings(userId: user.uid);
        bookings.listenToNotifications(user.uid);
        break;
      case UserRole.organizer:
        bookings.listenToNotifications(user.uid);
        break;
      case UserRole.admin:
        context.read<UserProvider>().fetchUsers();
        bookings.listenToBookings();
        bookings.listenToNotifications(user.uid);
        break;
    }
  }
}
