import 'dart:convert';
import 'api_client.dart';
import '../models/reservation.dart';

class ReservationService {
  /// GET /reservations
  static Future<List<Reservation>> fetchReservations() async {
    final response = await ApiClient.get('/reservations', auth: true);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['data'] ?? decoded);
      return data.map((e) => Reservation.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Gagal memuat reservasi (${response.statusCode})');
  }

  /// POST /reservations
  static Future<Map<String, dynamic>> createReservation({
    required int userId,
    required int courtId,
    required String reservationDate, // 'YYYY-MM-DD'
    required String startTime,       // 'HH:mm'
    required String endTime,         // 'HH:mm'
  }) async {
    try {
      final response = await ApiClient.post(
        '/reservations',
        {
          'user_id': userId,
          'court_id': courtId,
          'reservation_date': reservationDate,
          'start_time': startTime,
          'end_time': endTime,
        },
        auth: true,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': Reservation.fromJson(data['data'] as Map<String, dynamic>),
        };
      }

      if (response.statusCode == 409) {
        return {
          'success': false,
          'conflict': true,
          'message': data['message'] ?? 'Waktu sudah dibooking',
          'recommended_slots': data['recommended_slots'] ?? [],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Gagal membuat reservasi',
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  /// DELETE /reservations/{id}
  static Future<bool> cancelReservation(int id) async {
    final response = await ApiClient.delete('/reservations/$id', auth: true);
    return response.statusCode == 200;
  }
}
