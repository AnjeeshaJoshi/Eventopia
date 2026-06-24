import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/app_provider.dart';
import '../../theme.dart';
import '../../widgets.dart';

class AdminProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final user = p.current;
    if (user == null) {
      return const Center(
        child: Text('No user logged in'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: C.violet),
            onPressed: () {
              final nameCtrl = TextEditingController(text: user.name);
              final phoneCtrl = TextEditingController(text: user.phone);

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Edit Profile'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: phoneCtrl,
                        decoration: const InputDecoration(labelText: 'Phone'),
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
                        if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill all fields')),
                          );
                          return;
                        }
                        p.updateProfile(user.id, nameCtrl.text, phoneCtrl.text);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile updated successfully')),
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
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
                    label: 'Email',
                    value: user.email),
                InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: user.phone),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GBtn(
              label: 'Reset Password',
              icon: Icons.lock_reset_rounded,
              onTap: () {
                final newPassCtrl = TextEditingController();
                final confirmPassCtrl = TextEditingController();

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
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

                          p.changePassword(user.id, newPassCtrl.text);
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
          ),
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GBtn(
              label: 'Sign Out',
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );

                Future.microtask(() {
                  p.logout();
                });
              },
              gradient: C.gRose,
              icon: Icons.logout_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
