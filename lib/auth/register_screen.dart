import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'app_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pwd = TextEditingController();
  final _confirm = TextEditingController();

  bool _hidePwd = true;
  bool _hideConfirm = true;
  bool _loading = false;
  String? _error;

  // Only attendees self-register; admins register organisers separately.
  // We still show the label so the user knows their role.
  final UserRole _role = UserRole.attendee;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _pwd.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });

    await Future.delayed(const Duration(milliseconds: 900));

    final err = context.read<AppProvider>().register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      password: _pwd.text,
      role: _role,
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (err != null) {
      setState(() => _error = err);
    } else {
      // Auto-login the newly registered attendee
      context.read<AppProvider>().login(_email.text.trim(), _pwd.text);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/attendee');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: const Color(0xFFF8FAFC),),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── Header bar ──────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Branding ──────────────────────────────────────────
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            gradient: C.gPrimary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                              color: const Color(0xFFEC4899).withOpacity(.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: const Icon(Icons.how_to_reg_rounded,
                              size: 34, color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Join Eventopia',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Form ─────────────────────────────────────────────
                    GCard(
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Role pill (read-only, informational)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14),
                              decoration: BoxDecoration(
                                color: C.attendee.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: C.attendee.withOpacity(.35)),
                              ),
                              child:
                              Row(
                                children: [
                                  Icon(Icons.person_rounded,
                                      color: C.attendee, size: 16),
                                  const SizedBox(width: 8),
                                  const Text('Registering as: ',
                                      style: TextStyle(
                                          fontSize: 13, color: C.t2)),
                                  Text('Attendee',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: C.attendee)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Full Name
                            AppField(
                              label: 'Full Name',
                              controller: _name,
                              prefix: Icons.person_outline_rounded,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Full name is required';
                                if (v.trim().length < 2)
                                  return 'Name is too short';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Email
                            AppField(
                              label: 'Email Address',
                              controller: _email,
                              keyboard: TextInputType.emailAddress,
                              prefix: Icons.email_outlined,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Email is required';
                                if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$')
                                    .hasMatch(v.trim()))
                                  return 'Enter a valid email address';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Phone
                            AppField(
                              label: 'Phone Number',
                              controller: _phone,
                              keyboard: TextInputType.phone,
                              prefix: Icons.phone_outlined,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Phone number is required';
                                if (v.trim().length < 7)
                                  return 'Enter a valid phone number';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Password
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
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Password is required';
                                if (v.length < 6)
                                  return 'Minimum 6 characters';
                                return null;
                              },
                            ),

                            // Strength bar (reactive)
                            AnimatedBuilder(
                              animation: _pwd,
                              builder: (_, __) =>
                                  PasswordStrengthBar(password: _pwd.text),
                            ),

                            const SizedBox(height: 14),

                            // Confirm
                            AppField(
                              label: 'Confirm Password',
                              controller: _confirm,
                              obscure: _hideConfirm,
                              prefix: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                icon: Icon(
                                  _hideConfirm
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  size: 18,
                                  color: C.t3,
                                ),
                                onPressed: () => setState(
                                        () => _hideConfirm = !_hideConfirm),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please confirm your password';
                                if (v != _pwd.text)
                                  return 'Passwords do not match';
                                return null;
                              },
                            ),

                            if (_error != null) ErrorBanner(_error!),

                            const SizedBox(height: 22),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: SizedBox(
                              width: double.infinity,
                              child: GBtn(
                                label: 'Create Account',
                                onTap: _submit,
                                loading: _loading,
                                gradient: C.gPrimary,
                                icon: Icons.how_to_reg_rounded,
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Already have account ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?  ',
                            style: TextStyle(color: C.t2, fontSize: 14)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text('Sign In',
                              style: TextStyle(
                                  color: Color(0xFFEC4899),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}