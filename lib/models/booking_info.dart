import 'court.dart';

class BookingInfo {
  final int date;
  final String time;
  final int players;
  final double total;
  final Court court;

  BookingInfo({
    required this.date,
    required this.time,
    required this.players,
    required this.total,
    required this.court,
  });
}