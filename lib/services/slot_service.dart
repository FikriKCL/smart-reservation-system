import 'dart:convert';
import 'api_client.dart';

class SlotService {
  /// GET /courts/{courtId}/available-slots?date=YYYY-MM-DD
  static Future<List<Map<String, dynamic>>> fetchAvailableSlots({
    required String courtId,
    required String date,
  }) async {
    final response = await ApiClient.get(
      '/courts/$courtId/available-slots?date=$date',
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return List<Map<String, dynamic>>.from(decoded['data'] ?? []);
    }

    throw Exception('Gagal memuat slot tersedia (${response.statusCode})');
  }
}
