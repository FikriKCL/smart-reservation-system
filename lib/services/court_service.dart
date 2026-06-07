import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/court.dart';

class CourtService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<Court>> fetchCourts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courts'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data = decoded['data'] ?? decoded;

      return data.map((item) {
        return Court.fromJson(item);
      }).toList();
    } else {
      throw Exception(
        'Failed to fetch courts. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}
