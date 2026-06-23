import 'package:flutter/material.dart';

import '../../models.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selected;
  final Function(UserRole) onChanged;
  final bool showAdmin;

  const RoleSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.showAdmin = true,
  });

  Widget role(String title, UserRole role) {
    final isSelected = selected == role;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(role),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Colors.deepPurple.withOpacity(0.1)
                : Colors.white,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.deepPurple : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showAdmin) role("Admin", UserRole.admin),
        role("Organizer", UserRole.organizer),
        role("Attendee", UserRole.attendee),
      ],
    );
  }
}