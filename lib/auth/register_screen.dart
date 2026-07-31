import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets.dart';
import 'package:ems_app/providers/auth_provider.dart';
import '../utils/error_handler.dart';

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
  // show the label so the user knows their role.
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

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.register(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _pwd.text,
        role: _role.name,
      );

      if (!mounted) return;
      setState(() => _loading = false);

      if (authProvider.error != null) {
        setState(() => _error = authProvider.error);
      } else {
        // Auto-login the newly registered attendee
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/attendee');
        }
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
        decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: l.back,
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
                    // Branding
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
                        Semantics(
                          header: true,
                          child: Text(
                            l.createAccountTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l.joinEventopia,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Form
                    GCard(
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  Text('${l.registeringAs} ',
                                      style: const TextStyle(
                                          fontSize: 13, color: C.t2)),
                                  Text(l.attendee,
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
                              label: l.fullName,
                              controller: _name,
                              prefix: Icons.person_outline_rounded,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return l.fullNameIsRequired;
                                if (v.trim().length < 2)
                                  return l.nameIsTooShort;
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Email
                            AppField(
                              label: l.emailAddress,
                              controller: _email,
                              keyboard: TextInputType.emailAddress,
                              prefix: Icons.email_outlined,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return l.emailIsRequired;
                                if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$')
                                    .hasMatch(v.trim()))
                                  return l.enterValidEmail;
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Phone
                            AppField(
                              label: l.phoneNumber,
                              controller: _phone,
                              keyboard: TextInputType.phone,
                              prefix: Icons.phone_outlined,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return l.phoneIsRequired;
                                if (v.trim().length < 7)
                                  return l.enterValidPhone;
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // Password
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
                                if (v == null || v.isEmpty)
                                  return l.passwordIsRequired;
                                if (v.length < 6)
                                  return l.minimumSixChars;
                                return null;
                              },
                            ),

                            AnimatedBuilder(
                              animation: _pwd,
                              builder: (_, __) =>
                                  PasswordStrengthBar(password: _pwd.text),
                            ),

                            const SizedBox(height: 14),

                            // Confirm
                            AppField(
                              label: l.confirmPassword,
                              controller: _confirm,
                              obscure: _hideConfirm,
                              prefix: Icons.lock_outline_rounded,
                              suffix: IconButton(
                                tooltip: l.confirmPassword,
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
                                  return l.pleaseConfirmPassword;
                                if (v != _pwd.text)
                                  return l.passwordsDoNotMatch;
                                return null;
                              },
                            ),

                            if (_error != null) ErrorBanner(_error!),

                            const SizedBox(height: 20),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: SizedBox(
                              width: double.infinity,
                              child: Semantics(
                                button: true,
                                label: l.createAccountTitle,
                                child: GBtn(
                                  label: l.createAccountTitle,
                                  onTap: _submit,
                                  loading: _loading,
                                  gradient: C.gPrimary,
                                ),
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${l.alreadyHaveAccount}  ',
                            style: const TextStyle(color: C.t2, fontSize: 12)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(l.signIn,
                              style: const TextStyle(
                                  color: Color(0xFFEC4899),
                                  fontSize: 12,
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
