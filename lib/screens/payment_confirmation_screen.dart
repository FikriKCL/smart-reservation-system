import 'package:flutter/material.dart';
import '../models/booking_info.dart';
import '../services/reservation_service.dart';
import '../services/payments_service.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../screens/other_screens.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final BookingInfo booking;
  final int paymentOptionId;
  final String paymentMethod;

  const PaymentConfirmationScreen({
    super.key,
    required this.booking,
    required this.paymentMethod,
    required this.paymentOptionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kSlate800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Detail booking card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kSlate50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kSlate200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Booking',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: kSlate800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _row('Lapangan', booking.court.name),
                  const SizedBox(height: 10),
                  _row('Tanggal', booking.reservationDate),
                  const SizedBox(height: 10),
                  _row('Waktu', '${booking.startTime} - ${booking.endTime}'),
                  const SizedBox(height: 10),
                  _row('Metode Bayar', paymentMethod),
                  const Divider(height: 24, color: kSlate200),
                  _row(
                    'Total',
                    'Rp ${booking.total.toInt()}',
                    highlight: true,
                  ),
                ],
              ),
            ),

            const Spacer(),

            PrimaryButton(
              label: 'Konfirmasi Pembayaran',
              onPressed: () => _handleConfirm(context),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: kSlate500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            color: highlight ? kGreen : kSlate700,
          ),
        ),
      ],
    );
  }

  Future<void> _handleConfirm(BuildContext context) async {
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: kGreen)),
    );

    // Buat reservasi dulu
    final reservationResult = await ReservationService.createReservation(
      userId: 1,
      courtId: int.parse(booking.court.id),
      reservationDate: booking.reservationDate,
      startTime: booking.startTime,
      endTime: booking.endTime,
    );

    if (!context.mounted) return;

    if (reservationResult['success'] == true) {
      final reservationId = reservationResult['data'].id as int;

      // Buat pembayaran
      final paymentResult = await PaymentService.createPayment(
        reservationId: reservationId,
        paymentOptionId: paymentOptionId,
        amount: booking.total.toInt(),
      );

      if (!context.mounted) return;
      Navigator.pop(context); // tutup loading

      if (paymentResult['success'] == true) {
        Navigator.pop(context, {
  'success': true,
  'reservationId': reservationId,
});
      } else {
        _showSnack(context, paymentResult['message'] ?? 'Pembayaran gagal');
      }
    } else {
      if (!context.mounted) return;
      Navigator.pop(context); // tutup loading
      _showSnack(context, reservationResult['message'] ?? 'Reservasi gagal');
    }
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
