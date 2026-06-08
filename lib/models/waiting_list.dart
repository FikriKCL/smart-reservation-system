import 'court.dart';

class WaitingList {
  final int id;
  final int userId;
  final int courtId;
  final String reservationDate;
  final String requestedTime;
  final int position;
  final Court? court;

  WaitingList({
    required this.id,
    required this.userId,
    required this.courtId,
    required this.reservationDate,
    required this.requestedTime,
    required this.position,
    this.court,
  });

  factory WaitingList.fromJson(Map<String, dynamic> json) {
    return WaitingList(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      courtId: json['court_id'] ?? 0,
      reservationDate: json['reservation_date'] ?? '',
      requestedTime: (json['requested_time'] ?? '').substring(0, 5),
      position: json['position'] ?? 0,
      court: json['court'] != null
          ? Court.fromJson(json['court'] as Map<String, dynamic>)
          : null,
    );
  }
}
