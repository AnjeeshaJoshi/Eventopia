import 'package:ems_app/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../admin/tabs/changepassword_screen.dart';
import '../theme.dart';
import '../widgets.dart';
import 'register_screen.dart';
import 'package:provider/provider.dart';
import 'app_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState(
  );
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

    if (!_form.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final prov = context.read<AppProvider>();

    final err = prov.login(
      _email.text.trim(),
      _pwd.text,
    );

    if (!mounted) return;

    setState(() => _loading = false);

    if (err != null) {
      setState(() => _error = err);
    } else {
      final user = prov.current!;
      if (user.role == UserRole.organizer && user.mustChangePassword) {
        // Navigate to organizer dashboard (profile tab) for password change
        Navigator.pushReplacementNamed(context, '/organizer');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please change your default password to continue.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      } else {
        _navigate(user.role);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                          const Text(
                            'Eventopia',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Login to continue',
                            style: TextStyle(
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
                                    label: 'Email Address',
                                    controller: _email,
                                    keyboard: TextInputType.emailAddress,
                                    prefix: Icons.email_outlined,
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Email is required'
                                            : null,
                                  ),
                                  const SizedBox(height: 14),
                                  AppField(
                                    label: 'Password',
                                    controller: _pwd,
                                    obscure: _hidePwd,
                                    prefix: Icons.lock_outline_rounded,
                                    suffix: IconButton(
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
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? 'Password is required'
                                        : null,
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
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Color(0xFFEC4899),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_error != null) ErrorBanner(_error!),

                                  const SizedBox(height: 18),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                                    child: GBtn(
                                      label: 'Log In',
                                      onTap: _login,
                                      loading: _loading,
                                      icon: Icons.login_rounded,
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
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Create Account",
                                    style: TextStyle(
                                      color: Color(0xFFEC4899),
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
}
