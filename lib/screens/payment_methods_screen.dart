import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../models/booking_info.dart';
import '../models/payment_option.dart';
import '../services/payment_option_service.dart';
import 'payment_confirmation_screen.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final BookingInfo booking;

  const PaymentMethodsScreen({super.key, required this.booking});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int? _selectedIndex;
  late Future<List<PaymentOption>> _future;

  @override
  void initState() {
    super.initState();
    _future = PaymentOptionService.fetchPaymentOptions();
  }

  IconData _iconFor(String icon) {
    switch (icon) {
      case 'qr':
        return Icons.qr_code_2;
      case 'cash':
        return Icons.payments;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kSlate800,
      ),
      body: FutureBuilder<List<PaymentOption>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kGreen));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: kSlate400),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat metode pembayaran', style: TextStyle(color: kSlate500)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() {
                      _future = PaymentOptionService.fetchPaymentOptions();
                    }),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final methods = snapshot.data ?? [];

          if (methods.isEmpty) {
            return const Center(
              child: Text('Tidak ada metode pembayaran.', style: TextStyle(color: kSlate500)),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kSlate800,
                  ),
                ),
                const SizedBox(height: 16),

                // Daftar metode
                ...List.generate(methods.length, (i) {
                  final m = methods[i];
                  final selected = _selectedIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? kGreenLight : kSlate50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? kGreen : kSlate200,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selected ? kGreen.withOpacity(0.15) : kSlate100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_iconFor(m.icon), color: kGreen, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              m.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: selected ? kGreenDark : kSlate700,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? kGreen : Colors.transparent,
                              border: Border.all(
                                color: selected ? kGreen : kSlate300,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check, color: Colors.white, size: 13)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                const Spacer(),

                PrimaryButton(
                  label: 'Lanjutkan',
                  onPressed: () async {
                    if (_selectedIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Pilih metode pembayaran terlebih dahulu.'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                      return;
                    }
                    final selected = methods[_selectedIndex!];
                    final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => PaymentConfirmationScreen(
      booking: widget.booking,
      paymentOptionId: selected.id,
      paymentMethod: selected.label,
    ),
  ),
);

if (result != null && result['success'] == true) {
  Navigator.pop(context, result);
}
                  },
                  width: double.infinity,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
