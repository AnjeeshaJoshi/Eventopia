import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'theme.dart';

// ── GradientButton ────────────────────────────────────────────────────────────
class GBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Gradient gradient;
  final bool loading;
  final IconData? icon;
  final double height;
  final double ? width;

  const GBtn({
    super.key,
    required this.label,
    this.onTap,
    this.gradient = C.gPrimary,
    this.loading = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: onTap == null ? null : gradient,
          color: onTap == null ? C.border : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: onTap != null
              ? [
            BoxShadow(
              color: C.violet.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ]
              : null,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Colors.white),
          )
              :Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
              ],

              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

// ── GlassCard ─────────────────────────────────────────────────────────────────
class GCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GCard({
    super.key,
    required this.child,
    this.padding,
    this.radius = 20,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: box);
    }
    return box;
  }
}

// ── AppField ──────────────────────────────────────────────────────────────────
class AppField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final IconData? prefix;
  final Widget? suffix;
  final int maxLines;
  final String? hint;
  final Function(String)? onChanged;

  const AppField({
    super.key,
    required this.label,
    this.controller,
    this.obscure = false,
    this.keyboard,
    this.validator,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 12, color: Color(0xFF13131F)),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix != null
            ? Icon(prefix, size: 19, color: C.t3)
            : null,
        suffixIcon: suffix,
      ),
    );
  }
}

// ── SectionTitle ──────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: C.t1)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!,
                style: const TextStyle(
                    fontSize: 13,
                    color: C.violet,
                    fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }
}

// ── EventCard ─────────────────────────────────────────────────────────────────
class EventCard extends StatelessWidget {
  final AppEvent event;
  final VoidCallback? onTap;
  final bool compact;

  const EventCard(
      {super.key, required this.event, this.onTap, this.compact = false});

  static const _icons = {
    'concert': Icons.music_note_rounded,
    'conference': Icons.business_center_rounded,
    'workshop': Icons.build_rounded,
    'jazz': Icons.piano_rounded,
  };

  IconData get _icon {
    final t = event.title.toLowerCase();
    for (final k in _icons.keys) {
      if (t.contains(k)) return _icons[k]!;
    }
    return Icons.event_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final pct = event.occupancyRate;
    final barColor = pct > .8
        ? C.rose
        : pct > .5
        ? C.amber
        : C.teal;

    return GCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner – show poster image if available
          Container(
            height: compact ? 72 : 96,
            decoration: BoxDecoration(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (event.posterPath != null)
                  Image.file(
                    File(event.posterPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _gradientBanner(compact),
                  )
                else
                  _gradientBanner(compact),
                // Slight dark overlay for chip readability on images
                if (event.posterPath != null)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _StatusChip(event.status),
                ),
                if (event.isSoldOut)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _chip('SOLD OUT', C.rose),
                  ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: C.t3),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('EEE, MMM d').format(event.date)}  •  ${event.start.format(context)}',
                      style: const TextStyle(fontSize: 12, color: C.t2),
                    ),
                  ],
                ),
                if (!compact) ...[
                  const SizedBox(height: 10),
                  // Occupancy bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: C.surface,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(barColor),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.isSoldOut
                            ? 'Full'
                            : '${event.availableSeats} left',
                        style: TextStyle(fontSize: 11, color: barColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'From NPR ${event.lowestPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: C.violet),
                      ),
                      Text(event.organizerName,
                          style: const TextStyle(
                              fontSize: 11, color: C.t3)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientBanner(bool compact) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          C.violet.withOpacity(.7),
          C.indigo.withOpacity(.5),
        ],
      ),
    ),
    child: Center(
      child: Icon(_icon,
          size: compact ? 32 : 44,
          color: Colors.white.withOpacity(.25)),
    ),
  );

  Widget _chip(String t, Color c) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: c.withOpacity(.9),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(t,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white)),
  );
}

class _StatusChip extends StatelessWidget {
  final EventStatus status;
  const _StatusChip(this.status);
  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: status.color.withOpacity(.9),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(status.label,
        style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white)),
  );
}

// ── StatBox ───────────────────────────────────────────────────────────────────
class StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? sub;

  const StatBox({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: C.t2,
            ),
          ),

          if (sub != null) ...[
            const SizedBox(height: 1),
            Text(
              sub!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: C.t3,
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
// ── TicketChip ────────────────────────────────────────────────────────────────
class TicketChip extends StatelessWidget {
  final TicketCategory cat;
  const TicketChip({super.key, required this.cat});
  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: cat.color.withOpacity(.15),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: cat.color.withOpacity(.4)),

    ),
    child: Text(cat.label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: cat.color)),
  );
}

// ── InfoRow ───────────────────────────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoRow(
      {super.key,
        required this.icon,
        required this.label,
        required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: C.t3),
          const SizedBox(width: 10),
          Text('$label  ', style: const TextStyle(fontSize: 13, color: C.t2)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: C.t1),
                textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

// ── RoleBadge ─────────────────────────────────────────────────────────────────
class RoleBadge extends StatelessWidget {
  final UserRole role;
  const RoleBadge({super.key, required this.role});

  Color get _color {
    switch (role) {
      case UserRole.admin:     return C.admin;
      case UserRole.organizer: return C.org;
      case UserRole.attendee:  return C.attendee;
    }
  }

  String get _label {
    switch (role) {
      case UserRole.admin:     return 'Admin';
      case UserRole.organizer: return 'Organizer';
      case UserRole.attendee:  return 'Attendee';
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: _color.withOpacity(.15),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: _color.withOpacity(.4)),
    ),
    child: Text(_label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _color)),
  );
}

// ── PasswordStrengthBar ───────────────────────────────────────────────────────
class PasswordStrengthBar extends StatelessWidget {
  final String password;
  const PasswordStrengthBar({super.key, required this.password});

  double get _score {
    if (password.isEmpty) return 0;
    double s = 0;
    if (password.length >= 8) s += .25;
    if (password.contains(RegExp(r'[A-Z]'))) s += .25;
    if (password.contains(RegExp(r'[0-9]'))) s += .25;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) s += .25;
    return s;
  }

  Color get _color {
    final s = _score;
    if (s <= .25) return C.rose;
    if (s <= .50) return C.amber;
    if (s <= .75) return C.sky;
    return C.teal;
  }

  String get _label {
    final s = _score;
    if (s <= .25) return 'Weak';
    if (s <= .50) return 'Fair';
    if (s <= .75) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _score,
            backgroundColor: C.surface,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text('Password strength: $_label',
            style: TextStyle(fontSize: 11, color: _color)),
      ],
    );
  }
}

// ── ErrorBanner ───────────────────────────────────────────────────────────────
class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner(this.message, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: C.rose.withOpacity(.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: C.rose.withOpacity(.35)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded,
            color: C.rose, size: 16),
        const SizedBox(width: 8),
        Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 12, color: C.rose))),
      ],
    ),
  );
}

// ── SuccessView ───────────────────────────────────────────────────────────────
class SuccessView extends StatelessWidget {
  final String title;
  final String subtitle;
  final String btnLabel;
  final VoidCallback onTap;
  final IconData icon;

  const SuccessView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.btnLabel,
    required this.onTap,
    this.icon = Icons.check_circle_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: C.teal.withOpacity(.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: C.teal, size: 48),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style:
                const TextStyle(fontSize: 14, color: C.t2),
                textAlign: TextAlign.center),

            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 180,
                child: GBtn(
                    label: btnLabel,
                    onTap: onTap),
              ),
            )
          ],
        ),
      ),
    );
  }
}