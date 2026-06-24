import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class RegisterOrgSheet extends StatefulWidget {
  const RegisterOrgSheet();

  @override
  State<RegisterOrgSheet> createState() => _RegisterOrgSheetState();
}

class _RegisterOrgSheetState extends State<RegisterOrgSheet> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _org = TextEditingController();
  bool _loading = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _org.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(milliseconds: 800));

    final err = context.read<AppProvider>().register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          password: 'Org@1234',
          role: UserRole.organizer,
          organization: _org.text.trim().isEmpty ? null : _org.text.trim(),
        );

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (err != null)
        _error = err;
      else
        _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .95,
      minChildSize: .7,
      maxChildSize: 1.0,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: _done
            ? SuccessView(
                title: 'Organiser Registered!',
                subtitle:
                    'Login credentials have been assigned to the organiser. '
                    'They can use the default password (Org@1234) and change it on first login.',
                btnLabel: 'Done',
                onTap: () => Navigator.pop(context),
              )
            : Form(
                key: _form,
                child: ListView(
                  controller: sc,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: C.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const Text('Register New Organiser',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    const Text(
                        'A default password (Org@1234) will be assigned and emailed to the organiser. They must change it on first login.',
                        style: TextStyle(fontSize: 12, color: C.t2)),
                    const SizedBox(height: 20),
                    AppField(
                      label: 'Full Name',
                      controller: _name,
                      prefix: Icons.person_outline_rounded,
                      validator: (v) =>
                          v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Email Address',
                      controller: _email,
                      keyboard: TextInputType.emailAddress,
                      prefix: Icons.email_outlined,
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return 'Required';
                        if (!v!.contains('@')) return 'Invalid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Phone Number',
                      controller: _phone,
                      keyboard: TextInputType.phone,
                      prefix: Icons.phone_outlined,
                      validator: (v) =>
                          v?.trim().isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: 'Organisation Name (optional)',
                      controller: _org,
                      prefix: Icons.business_outlined,
                    ),
                    if (_error != null) ErrorBanner(_error!),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: GBtn(
                        label: 'Register Organiser',
                        onTap: _submit,
                        loading: _loading,
                        gradient: LinearGradient(
                            colors: [C.org, C.org.withOpacity(.7)]),
                        icon: Icons.person_add_rounded,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
