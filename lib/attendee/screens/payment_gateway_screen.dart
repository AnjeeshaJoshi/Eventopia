import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../widgets.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final double totalAmount;
  final VoidCallback onPaymentSuccess;

  const PaymentGatewayScreen({
    super.key,
    required this.totalAmount,
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
            const Text(
              'Total Amount to Pay',
              style: TextStyle(fontSize: 16, color: C.t2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'NPR ${widget.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: C.violet),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildMethodCard('Card', Icons.credit_card_rounded),
            const SizedBox(height: 12),
            _buildMethodCard('eSewa', Icons.account_balance_wallet_rounded),
            const SizedBox(height: 32),

            if (!_otpSent) ...[
              GBtn(
                label: 'Proceed to Pay',
                onTap: _processing ? null : _sendOtp,
                loading: _processing,
                icon: Icons.lock_outline_rounded,
              ),
            ] else ...[
              const Text(
                'Enter OTP to Confirm Payment',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              AppField(
                label: 'OTP (Default: 1234)',
                controller: _otpController,
                keyboard: TextInputType.number,
                prefix: Icons.password_rounded,
              ),
              const SizedBox(height: 20),
              GBtn(
                label: 'Verify & Pay',
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
