import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

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

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            password: 'Org@1234',
            role: UserRole.organizer.name,
            organization: _org.text.trim().isEmpty ? null : _org.text.trim(),
            preserveCurrentSession: true,
          );
      if (authProvider.error != null) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _error = authProvider.error;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error!)),
        );
        return;
      }

      if (!mounted) return;
      setState(() {
        _loading = false;
        _done = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            ? Semantics(
                liveRegion: true,
                child: SuccessView(
                  title: l.organiserRegistered,
                  subtitle: l.organiserLoginCredentialsAssigned,
                  btnLabel: l.done,
                  onTap: () => Navigator.pop(context),
                ),
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
                    Semantics(
                      header: true,
                      child: Text(l.registerNewOrganiser,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        l.defaultPasswordAssignedDesc,
                        style: const TextStyle(fontSize: 12, color: C.t2)),
                    const SizedBox(height: 20),
                    AppField(
                      label: l.fullName,
                      controller: _name,
                      prefix: Icons.person_outline_rounded,
                      validator: (v) =>
                          v?.trim().isEmpty == true ? l.requiredField : null,
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: l.emailAddress,
                      controller: _email,
                      keyboard: TextInputType.emailAddress,
                      prefix: Icons.email_outlined,
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return l.requiredField;
                        if (!v!.contains('@')) return l.invalidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: l.phoneNumber,
                      controller: _phone,
                      keyboard: TextInputType.phone,
                      prefix: Icons.phone_outlined,
                      validator: (v) =>
                          v?.trim().isEmpty == true ? l.requiredField : null,
                    ),
                    const SizedBox(height: 14),
                    AppField(
                      label: l.organisationNameOptional,
                      controller: _org,
                      prefix: Icons.business_outlined,
                    ),
                    if (_error != null)
                      Semantics(
                        liveRegion: true,
                        child: ErrorBanner(_error!),
                      ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Semantics(
                        button: true,
                        child: GBtn(
                          label: l.registerOrganiser,
                          onTap: _submit,
                          loading: _loading,
                          gradient: C.gPrimary,
                          icon: Icons.person_add_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
