import 'package:ems_app/attendee/widgets/qty_button.dart';
import 'package:ems_app/attendee/widgets/soldout_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ems_app/providers/auth_provider.dart';
import 'package:ems_app/providers/booking_provider.dart';
import 'package:ems_app/l10n/app_localizations.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../screens/payment_gateway_screen.dart';
import 'booking_confirmed_sheet.dart';

class BookingSheet extends StatefulWidget {
  final EventModel event;
  final TicketCategory? preSelectedCategory;
  final int? preSelectedQuantity;
  final List<String> preSelectedSeatIds;

  const BookingSheet({
    super.key,
    required this.event,
    this.preSelectedCategory,
    this.preSelectedQuantity,
    this.preSelectedSeatIds = const [],
  });
  @override
  State<BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<BookingSheet> {
  TicketCategory? _cat;
  int _qty = 1;
  final _promoCtrl = TextEditingController();
  bool _loading = false;
  String? _promoError;
  String? _promoSuccess;
  double _discountPct = 0;

  @override
  void initState() {
    super.initState();
    _cat = widget.preSelectedCategory;
    if (widget.preSelectedQuantity != null) {
      _qty = widget.preSelectedQuantity!;
    }
  }

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  EventModel get _event => widget.event;

  List<TicketType> get _available =>
      _event.ticketTypes.where((t) => t.available).toList();

  double get _basePrice =>
      _cat != null
          ? _event.ticketTypes
          .firstWhere((t) => t.category == _cat)
          .price
          : 0;

  double get _subtotal => _basePrice * _qty;

  double get _discount => _subtotal * (_discountPct / 100);

  double get _total => _subtotal - _discount;

  void _applyPromo() {
    final l = AppLocalizations.of(context)!;
    final code = _promoCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    try {
      final promo = _event.promoCodes.firstWhere((p) =>
          p.code.toUpperCase() == code &&
          p.valid &&
          (_cat == null || p.forCategories.contains(_cat)));
      setState(() {
        _promoError = null;
        _promoSuccess = l.promoApplied(promo.discountPct.toString());
        _discountPct = promo.discountPct;
      });
    } catch (_) {
      setState(() {
        _promoError = l.invalidPromoCode;
        _promoSuccess = null;
        _discountPct = 0;
      });
    }
  }

  Future<void> _proceedToPayment() async {
    if (_cat == null) return;
    final l = AppLocalizations.of(context)!;

    // Navigate to payment with the final total (after discount)
    final booking = await Navigator.push<BookingModel>(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentGatewayScreen(
          totalAmount: _total,
          subtotal: _subtotal,
          discount: _discount,
          promoCode: _discountPct > 0 ? _promoCtrl.text.trim() : null,
          eventTitle: _event.title,
          category: _cat!,
          quantity: _qty,
          onPaymentSuccess: () async {
            // Process actual booking upon successful payment
            try {
              final attendee = context.read<AuthProvider>().currentUser;
              if (attendee == null) {
                throw StateError('Please sign in before booking a ticket.');
              }
              final booking = await context.read<BookingProvider>().createBooking(
                eventId: _event.eventId,
                category: _cat!,
                quantity: _qty,
                promoCode:
                    _promoCtrl.text.trim().isEmpty ? null : _promoCtrl.text.trim(),
                seatIds: widget.preSelectedSeatIds,
                userId: attendee.uid,
                attendeeName: attendee.name,
              );

              if (!mounted) return null;

              if (booking == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.bookingFailed)),
                );
                return null;
              }
              return booking;
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l.bookingFailed}: $e')),
                );
              }
              return null;
            }
          },
        ),
      ),
    );

    if (!mounted || booking == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingConfirmedSheet(booking: booking),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    if (_event.isSoldOut) {
      return SoldOutSheet(event: _event);
    }

    return DraggableScrollableSheet(
      initialChildSize: .85,
      maxChildSize: .97,
      minChildSize: .4,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: ListView(
          controller: sc,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: C.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

            Text(_event.title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 13, color: C.t3),
                const SizedBox(width: 4),
                Text(
                  '${DateFormat('EEE, MMM d').format(_event.date)}  •  ${_event.start.format(context)}',
                  style: const TextStyle(fontSize: 12, color: C.t2),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Select category
            Text(l.selectTicketType,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            ..._available.map((type) {
              final selected = _cat == type.category;
              return GestureDetector(
                onTap: () => setState(() {
                  if (widget.preSelectedCategory != null) return;
                  _cat = type.category;
                  // Re-validate promo code when category changes
                  if (_promoCtrl.text.trim().isNotEmpty && _discountPct > 0) {
                    _applyPromo();
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected
                        ? type.category.color.withOpacity(.12)
                        : C.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? type.category.color
                          : C.border,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: selected
                              ? type.category.color
                              : C.border,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type.category.label,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            Text(type.category.section,
                                style: const TextStyle(
                                    fontSize: 11, color: C.t3)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'NPR ${type.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? type.category.color
                                  : C.t1,
                            ),
                          ),
                          Text(
                              l.countLeft(type.remaining.toString()),
                              style: const TextStyle(
                                  fontSize: 10, color: C.t3)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // Quantity
            Row(
              children: [
                Text(l.quantity,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                QtyButton(
                    icon: Icons.remove_rounded,
                    onTap: widget.preSelectedQuantity != null
                        ? null
                        : _qty > 1
                            ? () => setState(() => _qty--)
                            : null),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('$_qty',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                ),
                QtyButton(
                    icon: Icons.add_rounded,
                    onTap: widget.preSelectedQuantity != null
                        ? null
                        : _qty < 10
                            ? () => setState(() => _qty++)
                            : null),
              ],
            ),

            const SizedBox(height: 16),

            // Promo code
            Row(
              children: [
                Expanded(
                  child: AppField(
                    label: l.promoCodes,
                    controller: _promoCtrl,
                    prefix: Icons.discount_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                GBtn(
                  label: l.apply,
                  width: 90,
                  height: 50,
                  onTap: _applyPromo,
                  gradient:  C.gPrimary
                ),
              ],
            ),
            if (_promoError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_promoError!,
                    style: const TextStyle(fontSize: 11, color: C.rose)),
              ),
            if (_promoSuccess != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(_promoSuccess!,
                    style: const TextStyle(fontSize: 11, color: C.teal)),
              ),

            const SizedBox(height: 16),
            const Divider(color: C.border),
            const SizedBox(height: 8),

            // Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.subtotal,
                    style: const TextStyle(fontSize: 13, color: C.t2)),
                Text('NPR ${_subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            if (_discount > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${l.discount} (${_discountPct.toStringAsFixed(0)}%)',
                    style: const TextStyle(fontSize: 13, color: C.teal),
                  ),
                  Text('- NPR ${_discount.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: C.teal)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: C.violet.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: C.violet.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.total,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('NPR ${_total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: C.violet)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GBtn(
              label: _cat == null
                  ? l.selectTicketType
                  : l.proceedToPay,
              onTap: _cat != null ? _proceedToPayment : null,
              loading: _loading,
              gradient: C.gPrimary,
              icon: Icons.payment_rounded,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
