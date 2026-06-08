import 'package:flutter/material.dart';
import 'package:smart_reservation/utils/currency_formatter.dart';
import '../models/booking_info.dart';
import '../services/reservation_service.dart';
import '../services/payments_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

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
                    CurrencyFormatter.rupiah(booking.total),
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? kGreen : kSlate700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleConfirm(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: kGreen),
      ),
    );

    final reservationResult = await ReservationService.createReservation(
      courtId: (booking.court.id),
      reservationDate: booking.reservationDate,
      startTime: booking.startTime,
      endTime: booking.endTime,
    );

    if (!context.mounted) return;

    Navigator.pop(context); // tutup loading

    if (reservationResult['success'] == true) {
      final data = reservationResult['data'];

      final int reservationId = data is Map<String, dynamic>
          ? data['id']
          : data.id as int;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: kGreen),
        ),
      );

      final paymentResult = await PaymentService.createPayment(
        reservationId: reservationId,
        paymentOptionId: paymentOptionId,
        amount: booking.total.toInt(),
      );

      if (!context.mounted) return;

      Navigator.pop(context); // tutup loading payment

      if (paymentResult['success'] == true) {
        Navigator.pop(context, {
          'success': true,
          'reservationId': reservationId,
        });
      } else {
        _showSnack(
          context,
          paymentResult['message'] ?? 'Pembayaran gagal',
        );
      }
    } else if (reservationResult['conflict'] == true) {
      _showConflictDialog(context, reservationResult);
    } else {
      _showSnack(
        context,
        reservationResult['message'] ?? 'Reservasi gagal',
      );
    }
  }

  void _showConflictDialog(
    BuildContext context,
    Map<String, dynamic> reservationResult,
  ) {
    final List slots = reservationResult['recommended_slots'] ?? [];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Slot Sudah Terisi',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: kSlate800,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              reservationResult['message'] ??
                  'Jadwal sudah dibooking pengguna lain.',
              style: const TextStyle(
                fontSize: 13,
                color: kSlate500,
              ),
            ),
            const SizedBox(height: 14),
            if (slots.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rekomendasi slot lain:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kSlate700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...slots.map((slot) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kSlate50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kSlate200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: kGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${slot['start_time']} - ${slot['end_time']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kSlate700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else
              const Text(
                'Tidak ada slot alternatif yang tersedia.',
                style: TextStyle(
                  fontSize: 13,
                  color: kSlate500,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke payment methods / date flow
            },
            child: const Text(
              'Pilih Jadwal Lain',
              style: TextStyle(
                color: kGreen,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}