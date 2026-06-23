import 'package:flutter/material.dart';

import '../../theme.dart';

class QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const QtyButton({required this.icon, this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: onTap != null
            ? C.violet.withOpacity(.15)
            : C.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: onTap != null
              ? C.violet.withOpacity(.4)
              : C.border,
        ),
      ),
      child: Icon(icon,
          color: onTap != null ? C.violet : C.t3, size: 18),
    ),
  );
}
