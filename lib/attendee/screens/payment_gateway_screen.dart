import 'package:flutter/material.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';
import 'package:ems_app/l10n/app_localizations.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final double totalAmount;
  final double subtotal;
  final double discount;
  final String? promoCode;
  final String eventTitle;
  final TicketCategory category;
  final int quantity;
  final Future<BookingModel?> Function() onPaymentSuccess;

  const PaymentGatewayScreen({
    super.key,
    required this.totalAmount,
    required this.subtotal,
    required this.discount,
    this.promoCode,
    required this.eventTitle,
    required this.category,
    required this.quantity,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  String _selectedMethod = 'Card';
  bool _processing = false;
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _completeDemoPayment() async {
    if (!RegExp(r'^\d{4}$').hasMatch(_pinController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a 4-digit PIN to continue.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final booking = await widget.onPaymentSuccess();
      if (!mounted) return;
      if (booking == null) {
        setState(() => _processing = false);
        return;
      }
      Navigator.pop(context, booking);
    } catch (_) {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    Text(l.enterPin);
    return Scaffold(
      appBar: AppBar(title: Text(l.payment)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Order Summary Card
            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.orderSummary,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  InfoRow(
                    icon: Icons.event_rounded,
                    label: l.event,
                    value: widget.eventTitle,
                  ),
                  InfoRow(
                    icon: Icons.confirmation_number_rounded,
                    label: l.ticket,
                    value: '${widget.category.label} × ${widget.quantity}',
                  ),
                  const Divider(color: C.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.subtotal,
                          style: TextStyle(fontSize: 13, color: C.t2)),
                      Text('NPR ${widget.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  if (widget.discount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.discount_rounded,
                                  size: 14, color: C.teal),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  l.promoCode(widget.promoCode ?? ''),
                                  style: const TextStyle(
                                      fontSize: 13, color: C.teal),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(l.negativeNprAmount(widget.discount.toStringAsFixed(2)),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: C.teal)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                    decoration: BoxDecoration(
                      color: C.violet.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l.totalToPay,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'NPR ${widget.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: C.violet),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Methods
            Text(
              l.selectPaymentMethod,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildMethodCard(l.card, Icons.credit_card_rounded),
            const SizedBox(height: 12),
            _buildMethodCard(l.esewa, Icons.account_balance_wallet_rounded),
            const SizedBox(height: 24),

            Text(
              l.enterPin,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            AppField(
              label: l.enterPin,
              controller: _pinController,
              keyboard: TextInputType.number,
              obscure: true,
              prefix: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 48),
              child: GBtn(
                label: l.pay,
                onTap: _processing ? null : _completeDemoPayment,
                loading: _processing,
                icon: Icons.check_circle_outline_rounded,
              ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(String title, IconData icon) {
    final isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? C.violet.withOpacity(0.05) : C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? C.violet : C.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? C.violet : C.t3, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? C.violet : C.t1,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: C.violet, size: 24),
          ],
        ),
      ),
    );
  }
}
