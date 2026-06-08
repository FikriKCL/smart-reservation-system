import 'court.dart';

class Reservation {
  final int id;
  final int userId;
  final int courtId;
  final String reservationDate;
  final String startTime;
  final String endTime;
  final int duration;
  final int totalPrice;
  final String status; // pending | approved | cancelled
  final Court? court;

  Reservation({
    required this.id,
    required this.userId,
    required this.courtId,
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalPrice,
    required this.status,
    this.court,
  });

factory Reservation.fromJson(Map<String, dynamic> json) {
  print('STATUS FROM API = ${json['status']}');

  return Reservation(
    id: json['id'] ?? 0,
    userId: json['user_id'] ?? 0,
    courtId: json['court_id'] ?? 0,
    reservationDate: json['reservation_date'] ?? '',
    startTime: (json['start_time'] ?? '').substring(0, 5),
    endTime: (json['end_time'] ?? '').substring(0, 5),
    duration: json['duration'] ?? 1,
    totalPrice: json['total_price'] ?? 0,
    status: json['status'] ?? 'pending',
    court: json['court'] != null
        ? Court.fromJson(json['court'])
        : null,
  );
}

  bool get isPending   => status == 'pending';
  bool get isApproved  => status == 'approved';
  bool get isCancelled => status == 'cancelled';
}
