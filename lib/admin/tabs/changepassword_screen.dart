import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import '../../theme.dart';
import '../../widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);
    try {
      await context.read<AuthProvider>().resetPassword(_email.text.trim());
      if (!mounted) return;
      setState(() => _sent = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_sent) {
      final title = languageCode == 'ne'
          ? 'रिसेट लिंक पठाइयो'
          : languageCode == 'hi'
              ? 'रीसेट लिंक भेज दिया गया'
              : 'Check your email';
      final message = languageCode == 'ne'
          ? 'हामीले ${_email.text.trim()} मा पासवर्ड रिसेट लिंक पठाएका छौं। इनबक्स र स्प्याम जाँच्नुहोस्।'
          : languageCode == 'hi'
              ? 'हमने ${_email.text.trim()} पर पासवर्ड रीसेट लिंक भेज दिया है। इनबॉक्स और स्पैम जाँचें।'
              : 'We sent a password-reset link to ${_email.text.trim()}. Check your inbox and spam folder.';
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: GCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: C.teal.withOpacity(.12),
                      ),
                      child: const Icon(Icons.mark_email_read_rounded,
                          color: C.teal, size: 38),
                    ),
                    const SizedBox(height: 20),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: C.t2, height: 1.5)),
                    const SizedBox(height: 24),
                    GBtn(
                      label: l.back,
                      onTap: () => Navigator.pop(context),
                      icon: Icons.arrow_back_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    final resetDescription = languageCode == 'ne'
        ? 'तपाईंको इमेल प्रविष्ट गर्नुहोस्। हामी सुरक्षित पासवर्ड रिसेट लिंक पठाउनेछौं।'
        : languageCode == 'hi'
            ? 'अपना ईमेल दर्ज करें। हम आपको सुरक्षित पासवर्ड रीसेट लिंक भेजेंगे।'
            : 'Enter your email and we will send a secure password-reset link.';
    final sendResetLink = languageCode == 'ne'
        ? 'रिसेट लिंक पठाउनुहोस्'
        : languageCode == 'hi'
            ? 'रीसेट लिंक भेजें'
            : 'Send reset link';
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withOpacity(.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 50,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 20),
            Semantics(
              label: l.changePassword,
              child: Text(
                l.changePassword,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resetDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l.emailAddress,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l.emailIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C3AED),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _sending ? null : _resetPassword,
                            child: _sending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    sendResetLink,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
