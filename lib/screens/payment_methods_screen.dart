import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/primary_button.dart';
import '../models/booking_info.dart';
import '../models/payment_option.dart';
import '../services/payment_option_service.dart';
import 'payment_confirmation_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final BookingInfo booking;

  const PaymentMethodsScreen({
    super.key,
    required this.booking,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int? _selectedMethod;
  late Future<List<PaymentOption>> _paymentOptionsFuture;

  @override
  void initState() {
    super.initState();
    _paymentOptionsFuture = PaymentOptionService.fetchPaymentOptions();
  }

  Widget _getPaymentIcon(String icon) {
    switch (icon) {
      case 'qr':
        return const Icon(Icons.qr_code_2, color: AppTheme.primaryGreen, size: 28);
      case 'cash':
        return const Icon(Icons.payments, color: AppTheme.primaryGreen, size: 28);
      case 'wallet':
        return const Icon(Icons.account_balance_wallet, color: AppTheme.primaryGreen, size: 28);
      case 'card':
        return const Icon(Icons.credit_card, color: AppTheme.primaryGreen, size: 28);
      default:
        return const Icon(Icons.payment, color: AppTheme.primaryGreen, size: 28);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Payment'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<PaymentOption>>(
          future: _paymentOptionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final methods = snapshot.data ?? [];

            if (methods.isEmpty) {
              return const Center(
                child: Text('No payment methods available.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkText,
                  ),
                ),

                const SizedBox(height: 16),

                ...List.generate(methods.length, (i) {
                  final method = methods[i];

                  return _PaymentTile(
                    label: method.label,
                    icon: _getPaymentIcon(method.icon),
                    isSelected: _selectedMethod == i,
                    onTap: () {
                      setState(() {
                        _selectedMethod = i;
                      });
                    },
                  );
                }),

                const Spacer(),

                PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    if (_selectedMethod == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih metode pembayaran terlebih dahulu.'),
                        ),
                      );
                      return;
                    }

                    final selectedMethod = methods[_selectedMethod!];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentConfirmationScreen(
                          booking: widget.booking,
                          paymentOptionId: selectedMethod.id,
                          paymentMethod: selectedMethod.label,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightGreen : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
            width: 1.5,
          ),
        ),

        child: Row(
          children: [
            SizedBox(width: 32, height: 32, child: icon),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: AppTheme.darkText,
                ),
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.primaryGreen
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryGreen
                      : AppTheme.greyText,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}