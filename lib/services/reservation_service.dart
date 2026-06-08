import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, dynamic>> createReservation({
    required int userId,
    required String courtId,
    required String reservationDate,
    required String startTime,
    required String endTime,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'court_id': courtId,
        'reservation_date': reservationDate,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'data': data['data'],
      };
    }

    if (response.statusCode == 409) {
      return {
        'success': false,
        'conflict': true,
        'message': data['message'],
        'recommended_slots': data['recommended_slots'] ?? [],
      };
    }

    return {
      'success': false,
      'conflict': false,
      'message': data['message'] ?? 'Failed to create reservation',
    };
  }
}