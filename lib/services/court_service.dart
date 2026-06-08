import 'dart:convert';
import 'api_client.dart';
import '../models/court.dart';

class CourtService {
  /// GET /courts — public endpoint, tidak butuh token
  static Future<List<Court>> fetchCourts() async {
    final response = await ApiClient.get('/courts');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List data = decoded['data'] ?? [];
      return data.map((e) => Court.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Gagal memuat lapangan (${response.statusCode})');
  }

  /// GET /courts/{id}
  static Future<Court> fetchCourt(String id) async {
    final response = await ApiClient.get('/courts/$id');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return Court.fromJson(decoded['data'] as Map<String, dynamic>);
    }

    throw Exception('Lapangan tidak ditemukan (${response.statusCode})');
  }
}
