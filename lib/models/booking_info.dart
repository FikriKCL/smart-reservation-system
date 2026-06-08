import 'court.dart';

class BookingInfo {
  final int date;           // day number (untuk display)
  final String dateStr;     // 'YYYY-MM-DD' (untuk API)
  final String startTime;   // 'HH:mm'
  final String endTime;     // 'HH:mm'
  final int players;
  final double total;
  final Court court;
  final int? reservationId; // diisi setelah API sukses

  BookingInfo({
    required this.date,
    required this.dateStr,
    required this.startTime,
    required this.endTime,
    required this.players,
    required this.total,
    required this.court,
    this.reservationId,
  });

  // Backward compat
  String get time => startTime;

  // FIX: tambah getter reservationDate agar PaymentConfirmationScreen tidak error
  String get reservationDate => dateStr;
}
