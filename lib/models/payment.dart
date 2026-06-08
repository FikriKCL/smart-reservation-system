import 'reservation.dart';

class Payment {
  final int id;
  final int reservationId;
  final int amount;
  final String status; // pending | paid
  final String? paidAt;
  final Reservation? reservation;

  Payment({
    required this.id,
    required this.reservationId,
    required this.amount,
    required this.status,
    this.paidAt,
    this.reservation,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      reservationId: json['reservation_id'] ?? 0,
      amount: json['amount'] ?? 0,
      status: json['status'] ?? 'pending',
      paidAt: json['paid_at'] as String?,
      reservation: json['reservation'] != null
          ? Reservation.fromJson(json['reservation'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get isPaid => status == 'paid';
}
