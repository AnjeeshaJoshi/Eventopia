import 'package:flutter/material.dart';

import '../../models.dart';
import '../../theme.dart';
import '../../widgets.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final double totalAmount;
  final double subtotal;
  final double discount;
  final String? promoCode;
  final String eventTitle;
  final TicketCategory category;
  final int quantity;
  final VoidCallback onPaymentSuccess;

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
  bool _otpSent = false;
  bool _processing = false;
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    setState(() {
      _processing = false;
      _otpSent = true;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has been sent to your registered mobile/email. (Default: 1234)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _verifyOtp() async {
    if (_otpController.text.trim() != '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: C.rose,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate payment processing
    if (mounted) {
      Navigator.pop(context); // Close payment screen
      widget.onPaymentSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // ── Order Summary Card ─────────────────────────────────
            GCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  InfoRow(
                    icon: Icons.event_rounded,
                    label: 'Event',
                    value: widget.eventTitle,
                  ),
                  InfoRow(
                    icon: Icons.confirmation_number_rounded,
                    label: 'Ticket',
                    value: '${widget.category.label} × ${widget.quantity}',
                  ),
                  const Divider(color: C.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal',
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
                                  'Promo: ${widget.promoCode ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 13, color: C.teal),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('- NPR ${widget.discount.toStringAsFixed(2)}',
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
                        const Text('Total to Pay',
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

            // ── Payment Methods ────────────────────────────────────
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _buildMethodCard('Card', Icons.credit_card_rounded),
            const SizedBox(height: 12),
            _buildMethodCard('eSewa', Icons.account_balance_wallet_rounded),
            const SizedBox(height: 24),

            // ── OTP / Pay Button ───────────────────────────────────
            if (!_otpSent) ...[
              Padding(padding: const EdgeInsets.symmetric(horizontal: 80),
              child: GBtn(
                label: 'Pay',
                onTap: _processing ? null : _sendOtp,
                loading: _processing,
                icon: Icons.lock_outline_rounded,
              ),
              ),
            ] else ...[
              const Text(
                'Enter OTP to Confirm Payment',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              AppField(
                label: 'OTP : 1234',
                controller: _otpController,
                keyboard: TextInputType.number,
                prefix: Icons.password_rounded,
              ),
              const SizedBox(height: 20),
              GBtn(
                label: 'Verify & Pay – NPR ${widget.totalAmount.toStringAsFixed(2)}',
                onTap: _processing ? null : _verifyOtp,
                loading: _processing,
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(String title, IconData icon) {
    final isSelected = _selectedMethod == title;
    return GestureDetector(
      onTap: _otpSent ? null : () => setState(() => _selectedMethod = title),
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
