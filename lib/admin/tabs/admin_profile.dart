import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/user_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userProvider = context.watch<UserProvider>();
    final l = AppLocalizations.of(context)!;
    
    final user = authProvider.currentUser;
    if (user == null) {
      return Center(
        child: Text(l.noUserLoggedIn),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.myProfile),
        actions: [
          Tooltip(
            message: l.editProfile,
            child: Semantics(
              button: true,
              label: l.editProfile,
              child: IconButton(
                icon: const Icon(Icons.edit_rounded, color: C.violet),
                onPressed: () {
                  final nameCtrl = TextEditingController(text: user.name);
                  final phoneCtrl = TextEditingController(text: user.phone);

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      scrollable: true,
                      insetPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      title: Text(l.editProfile),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameCtrl,
                            decoration: InputDecoration(labelText: l.name),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: phoneCtrl,
                            decoration: InputDecoration(labelText: l.phone),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l.pleaseFillAllFields)),
                              );
                              return;
                            }
                            try {
                              await userProvider.updateProfile(uid: user.uid, name: nameCtrl.text, phone: phoneCtrl.text);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l.profileUpdatedSuccessfully)),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: Text(l.save),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: C.attendee.withOpacity(.15),
                  child: Text(user.name[0],
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: C.attendee)),
                ),
                const SizedBox(height: 12),
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                RoleBadge(role: user.role),
                const SizedBox(height: 16),
                const Divider(color: C.border),
                const SizedBox(height: 8),
                InfoRow(
                    icon: Icons.email_outlined,
                    label: l.email,
                    value: user.email),
                InfoRow(
                    icon: Icons.phone_outlined,
                    label: l.phone,
                    value: user.phone),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Semantics(
              button: true,
              label: l.resetPassword,
              child: GBtn(
                label: l.resetPassword,
                icon: Icons.lock_reset_rounded,
                onTap: () {
                  final newPassCtrl = TextEditingController();
                  final confirmPassCtrl = TextEditingController();

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(l.resetPassword),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: newPassCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: l.newPassword,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmPassCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: l.confirmPassword,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (newPassCtrl.text.isEmpty ||
                                confirmPassCtrl.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l.pleaseFillAllFields),
                                ),
                              );
                              return;
                            }

                            if (newPassCtrl.text != confirmPassCtrl.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l.passwordsDoNotMatch),
                                ),
                              );
                              return;
                            }
                            
                            try {
                              await authProvider.changePassword(user.uid, newPassCtrl.text);
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l.passwordChangedSuccessfully),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            }
                          },
                          child: Text(l.update),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Semantics(
              button: true,
              label: l.signOut,
              child: GBtn(
                label: l.signOut,
                onTap: () async {
                  // Route first so the UI never remains on the protected admin
                  // dashboard while Firebase finishes clearing its session.
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                  try {
                    await authProvider.logout();
                  } catch (e) {
                    // The navigation is intentional even if the SDK reports a
                    // transient sign-out error; Firebase auth state will retry.
                  }
                },
                gradient: C.gPrimary,
                icon: Icons.logout_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
