import 'court.dart';

class BookingInfo {
  final String reservationDate;
  final String startTime;
  final String endTime;
  final double total;
  final Court court;

  BookingInfo({
    required this.reservationDate,
    required this.startTime,
    required this.endTime,
    required this.total,
    required this.court,
  });
}