import 'package:flutter/material.dart';
import '../models/booking_info.dart';
import '../services/reservation_service.dart';
import '../services/payments_service.dart';
import '../widgets/primary_button.dart';
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
      appBar: AppBar(
        title: const Text('Payment Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Court: ${booking.court.name}'),
            Text('Date: ${booking.reservationDate}'),
            Text('Time: ${booking.startTime} - ${booking.endTime}'),
            Text('Payment: $paymentMethod'),
            Text('Total: Rp ${booking.total.toInt()}'),

            const Spacer(),

            PrimaryButton(
              label: 'Confirm Payment',
              onPressed: () async {
                final reservationResult =
                    await ReservationService.createReservation(
                  userId: 1,
                  courtId: booking.court.id,
                  reservationDate: booking.reservationDate,
                  startTime: booking.startTime,
                  endTime: booking.endTime,
                );

                if (!context.mounted) return;

                if (reservationResult['success'] == true) {
                  final reservationId = reservationResult['data']['id'];

                  final paymentResult = await PaymentService.createPayment(
                    reservationId: reservationId,
                    paymentOptionId: paymentOptionId,
                    amount: booking.total.toInt(),
                  );

                  if (!context.mounted) return;

                if (paymentResult['success'] == true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuccessScreen(
                            booking: booking,
                            onDone: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                          ),
                        ),
                        (route) => false,
                      );
                    }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(paymentResult['message']),
                      ),
                    );
                  }
                } else if (reservationResult['conflict'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(reservationResult['message']),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(reservationResult['message']),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}