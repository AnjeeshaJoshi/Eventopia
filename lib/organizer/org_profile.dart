import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/app_provider.dart';
import '../theme.dart';
import '../widgets.dart';

class OrgProfile extends StatelessWidget {
  const OrgProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final user = p.current!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          children: [
            GCard(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: C.org.withOpacity(.15),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0] : '?',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: C.org,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  RoleBadge(role: user.role),

                  const SizedBox(height: 16),

                  const Divider(color: C.border),

                  const SizedBox(height: 8),

                  InfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user.email,
                  ),

                  InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone,
                  ),

                  if (user.organization != null)
                    InfoRow(
                      icon: Icons.business_outlined,
                      label: 'Organisation',
                      value: user.organization!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            GBtn(
              label: 'Reset Password',
              icon: Icons.lock_reset_rounded,
              onTap: () {
                final newPassCtrl = TextEditingController();
                final confirmPassCtrl = TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Password'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: newPassCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: confirmPassCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (newPassCtrl.text.isEmpty ||
                              confirmPassCtrl.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                              ),
                            );
                            return;
                          }

                          if (newPassCtrl.text != confirmPassCtrl.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                              ),
                            );
                            return;
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password changed successfully',
                              ),
                            ),
                          );
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            GBtn(
              label: 'Sign Out',
              gradient: C.gRose,
              icon: Icons.logout_rounded,
              onTap: () {
                p.logout();

                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}