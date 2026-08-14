import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ems_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models.dart';
import 'providers/locale_provider.dart';
import 'theme.dart';

/// A lightweight, brand-coloured loading indicator used for both full pages
/// and in-place actions. The staggered dots make waits feel active without
/// distracting from the task at hand.
class AppLoadingIndicator extends StatelessWidget {
  final double dotSize;
  final Color color;
  final String? label;

  const AppLoadingIndicator({
    super.key,
    this.dotSize = 10,
    this.color = C.violet,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          width: dotSize,
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: dotSize * .28),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        )
            .animate(
              delay: Duration(milliseconds: index * 140),
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .moveY(
              begin: 0,
              end: -dotSize * .65,
              duration: 560.ms,
              curve: Curves.easeInOut,
            )
            .fade(begin: .4, end: 1),
      ),
    );

    return Semantics(
      liveRegion: true,
      label: label ?? 'Loading',
      child: label == null
          ? dots
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                dots,
                const SizedBox(height: 14),
                Text(label!, style: const TextStyle(color: C.t2, fontSize: 13)),
              ],
            ),
    );
  }
}

class AppLoadingView extends StatelessWidget {
  final String? label;

  const AppLoadingView({super.key, this.label});

  @override
  Widget build(BuildContext context) => Center(
        child: AppLoadingIndicator(label: label),
      );
}

/// A compact, always-readable language picker. It is deliberately labelled
/// with both scripts so it remains usable before the app language changes.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.watch<LocaleProvider>().locale.languageCode;
    return Material(
      color: Colors.transparent,
      child: PopupMenuButton<String>(
        tooltip: 'Language / भाषा',
        onSelected: (languageCode) =>
            context.read<LocaleProvider>().setLocale(Locale(languageCode)),
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'en', child: Text('English')),
          PopupMenuItem(value: 'ne', child: Text('नेपाली')),
          PopupMenuItem(value: 'hi', child: Text('हिन्दी')),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: C.border),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 8),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: 18, color: C.violet),
              const SizedBox(width: 5),
              Text(
                currentLanguage == 'ne'
                    ? 'ने'
                    : currentLanguage == 'hi'
                        ? 'हि'
                        : 'EN',
                style: const TextStyle(
                  color: C.violet,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Notification control with a compact unread-count badge for dashboard headers.
class NotificationBell extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onPressed;
  final String tooltip;
  final Color color;

  const NotificationBell({
    super.key,
    required this.unreadCount,
    required this.onPressed,
    required this.tooltip,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final label = unreadCount > 99 ? '99+' : '$unreadCount';
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: unreadCount == 0 ? tooltip : '$tooltip, $unreadCount unread',
        child: IconButton(
          onPressed: onPressed,
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_outlined, color: color),
              if (unreadCount > 0)
                Positioned(
                  right: -7,
                  top: -7,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: C.rose,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: C.surface, width: 1.5),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
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

// GradientButton
class GBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Gradient gradient;
  final bool loading;
  final IconData? icon;
  final double height;
  final double? width;

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
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 18),
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: loading
                ? const AppLoadingIndicator(
                    key: ValueKey('loading'),
                    dotSize: 6,
                    color: Colors.white,
                  )
                : Row(
                    key: const ValueKey('label'),
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
      ),
    );
  }
}

// GlassCard
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
        prefixIcon: prefix != null ? Icon(prefix, size: 19, color: C.t3) : null,
        suffixIcon: suffix,
      ),
    );
  }
}

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

class EventCard extends StatelessWidget {
  final EventModel event;
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

  Widget _fallbackPoster() => Image.asset(
        'assets/images/cultural.jpg',
        fit: BoxFit.cover,
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pct = event.occupancyRate;
    final barColor = pct > .8
        ? C.rose
        : pct > .5
            ? C.amber
            : C.teal;

    return Semantics(
      button: true,
      label: event.title,
      child: GCard(
        onTap: onTap,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner – show poster image if available
            Container(
              height: compact ? 72 : 96,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (event.image != null)
                    event.image!.startsWith('assets/')
                        ? Image.asset(
                            event.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallbackPoster(),
                          )
                        : event.image!.startsWith('http')
                            ? Image.network(
                                event.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _fallbackPoster(),
                              )
                            : event.image!.startsWith('gs://')
                                ? _fallbackPoster()
                                : Image.file(
                                    File(event.image!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _fallbackPoster(),
                                  )
                  else
                    _fallbackPoster(),
                  // Slight dark overlay for chip readability on images
                  if (event.image != null)
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
                      child: _chip(l?.soldOut ?? 'SOLD OUT', C.rose),
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
                      Expanded(
                        child: Text(
                          '${DateFormat('EEE, MMM d').format(event.date)}  •  ${event.start.format(context)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: C.t2),
                        ),
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
                              ? (l?.full ?? 'Full')
                              : l?.countLeft(event.availableSeats.toString()) ??
                                  '${event.availableSeats} left',
                          style: TextStyle(fontSize: 11, color: barColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            l?.fromNpr(event.lowestPrice.toStringAsFixed(0)) ??
                                'From NPR ${event.lowestPrice.toStringAsFixed(0)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: C.violet),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            event.organizerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 11, color: C.t3),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String t, Color c) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
    return Semantics(
      label: '$label: $value',
      child: Container(
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
      ),
    );
  }
}

class TicketChip extends StatelessWidget {
  final TicketCategory cat;

  const TicketChip({super.key, required this.cat});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: cat.color.withOpacity(.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cat.color.withOpacity(.4)),
        ),
        child: Text(cat.label,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: cat.color)),
      );
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final int maxValueLines;

  const InfoRow(
      {super.key,
      required this.icon,
      required this.label,
      required this.value,
      this.maxValueLines = 2});

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
            child: Text(
              value,
              maxLines: maxValueLines,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: C.t1,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({super.key, required this.role});

  Color get _color {
    switch (role) {
      case UserRole.admin:
        return C.admin;
      case UserRole.organizer:
        return C.org;
      case UserRole.attendee:
        return C.attendee;
    }
  }

  String _label(BuildContext context) {
    final l = AppLocalizations.of(context);
    switch (role) {
      case UserRole.admin:
        return l?.admin ?? 'Admin';
      case UserRole.organizer:
        return l?.organiser ?? 'Organizer';
      case UserRole.attendee:
        return l?.attendee ?? 'Attendee';
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color.withOpacity(.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _color.withOpacity(.4)),
        ),
        child: Text(_label(context),
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w600, color: _color)),
      );
}

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

  String _label(BuildContext context) {
    final l = AppLocalizations.of(context);
    final s = _score;

    if (s <= .25) return l?.weak ?? 'Weak';
    if (s <= .50) return l?.fair ?? 'Fair';
    if (s <= .75) return l?.good ?? 'Good';

    return l?.strong ?? 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
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
        Text(
          l?.passwordStrength(_label(context)) ??
              'Password strength: ${_label(context)}',
          style: TextStyle(fontSize: 11, color: _color),
        ),
      ],
    );
  }
}

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
            const Icon(Icons.error_outline_rounded, color: C.rose, size: 16),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message,
                    style: const TextStyle(fontSize: 12, color: C.rose))),
          ],
        ),
      );
}

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
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(fontSize: 14, color: C.t2),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 180,
                child: GBtn(label: btnLabel, onTap: onTap),
              ),
            )
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 320.ms, curve: Curves.easeOut)
        .slideY(begin: .06, end: 0, duration: 320.ms, curve: Curves.easeOut);
  }
}
