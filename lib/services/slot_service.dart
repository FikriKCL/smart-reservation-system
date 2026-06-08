import 'dart:convert';
import 'package:http/http.dart' as http;

class SlotService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Map<String, dynamic>>> fetchAvailableSlots({
    required String courtId,
    required String date,
  }) async {
    final url = Uri.parse(
      '$baseUrl/courts/$courtId/available-slots?date=$date',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(decoded['data']);
    }

    throw Exception(response.body);
  }
}