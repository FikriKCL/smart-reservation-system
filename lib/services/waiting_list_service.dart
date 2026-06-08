import 'dart:convert';
import 'api_client.dart';
import '../models/waiting_list.dart';

class WaitingListService {
  /// GET /waiting-lists
  static Future<List<WaitingList>> fetchWaitingList() async {
    final response = await ApiClient.get('/waiting-lists', auth: true);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data = decoded is List ? decoded : (decoded['data'] ?? decoded);
      return data.map((e) => WaitingList.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Gagal memuat waiting list (${response.statusCode})');
  }

  /// POST /waiting-lists
  static Future<Map<String, dynamic>> joinWaitingList({
    required int courtId,
    required String reservationDate, // 'YYYY-MM-DD'
    required String requestedTime,   // 'HH:mm'
  }) async {
    try {
      final response = await ApiClient.post(
        '/waiting-lists',
        {
          'court_id': courtId,
          'reservation_date': reservationDate,
          'requested_time': requestedTime,
        },
        auth: true,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'position': data['position'],
          'message': data['message'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Gagal bergabung ke waiting list',
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  /// DELETE /waiting-lists/{id}
  static Future<bool> leaveWaitingList(int id) async {
    final response = await ApiClient.delete('/waiting-lists/$id', auth: true);
    return response.statusCode == 200;
  }
}
