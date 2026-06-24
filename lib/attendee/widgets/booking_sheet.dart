import 'package:ems_app/attendee/widgets/qty_button.dart';
import 'package:ems_app/attendee/widgets/soldout_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/app_provider.dart';
import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import '../screens/payment_gateway_screen.dart';
import 'booking_confirmed_sheet.dart';

class BookingSheet extends StatefulWidget {
  final AppEvent event;
  const BookingSheet({required this.event});
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

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  AppEvent get _event => widget.event;

  List<TicketType> get _available =>
      _event.ticketTypes.where((t) => t.available).toList();

  double get _basePrice =>
      _cat != null
          ? _event.ticketTypes
          .firstWhere((t) => t.category == _cat)
          .price
          : 0;

  double get _subtotal => _basePrice * _qty;

  Future<void> _book() async {
    if (_cat == null) return;

    // Navigate to payment gateway first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentGatewayScreen(
          totalAmount: _subtotal,
          onPaymentSuccess: () {
            // Process actual booking upon successful payment
            final booking = context.read<AppProvider>().book(
              eventId: _event.id,
              category: _cat!,
              quantity: _qty,
              promoCode:
                  _promoCtrl.text.trim().isEmpty ? null : _promoCtrl.text.trim(),
            );

            if (booking == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking failed. Please try again.')),
              );
              return;
            }

            Navigator.pop(context); // Close the booking sheet

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => BookingConfirmedSheet(booking: booking),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            const Text('Select Ticket Type',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            ..._available.map((type) {
              final selected = _cat == type.category;
              return GestureDetector(
                onTap: () => setState(() => _cat = type.category),
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
                          Text('${type.remaining} left',
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
                const Text('Quantity',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const Spacer(),
                QtyButton(
                    icon: Icons.remove_rounded,
                    onTap: _qty > 1
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
                    onTap: _qty < 10
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
                    label: 'Promo Code (optional)',
                    controller: _promoCtrl,
                    prefix: Icons.discount_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                GBtn(
                  label: 'Apply',
                  width: 80,
                  height: 50,
                  onTap: () {
                    final code = _promoCtrl.text.trim().toUpperCase();
                    if (code.isEmpty) return;
                    final found = _event.promoCodes.any((p) =>
                    p.code.toUpperCase() == code &&
                        p.valid &&
                        (_cat == null ||
                            p.forCategories.contains(_cat)));
                    setState(() {
                      _promoError = found ? null : 'Invalid or expired code';
                      _promoSuccess =
                      found ? 'Code applied!' : null;
                    });
                  },
                  gradient: C.gTeal,
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
                const Text('Subtotal',
                    style: TextStyle(fontSize: 13, color: C.t2)),
                Text('NPR ${_subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Service fee',
                    style: TextStyle(fontSize: 13, color: C.t2)),
                Text('NPR 0.00',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                Text('NPR ${_subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: C.teal)),
              ],
            ),

            const SizedBox(height: 20),

            GBtn(
              label: _cat == null
                  ? 'Select a ticket type'
                  : 'Confirm Booking – NPR ${_subtotal.toStringAsFixed(2)}',
              onTap: _cat != null ? _book : null,
              loading: _loading,
              gradient: C.gPrimary,
              icon: Icons.confirmation_number_rounded,
            ),
          ],
        ),
      ),
    );
  }
}