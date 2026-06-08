import 'dart:convert';
import 'api_client.dart';
import '../models/court.dart';

class CourtService {
  /// GET /courts — public endpoint, tidak butuh token
static Future<List<Court>> fetchCourts() async {
  final response = await ApiClient.get(
    '/courts',
    auth: true,
  );

  final data = jsonDecode(response.body);

  return (data as List)
      .map((e) => Court.fromJson(e))
      .toList();
}

static Future<List<Court>> getNearestCourts() async {
  final response = await ApiClient.get(
    '/courts/nearest',
    auth: true,
  );

  print('STATUS: ${response.statusCode}');
  print('BODY: ${response.body}');

  final List<dynamic> data =
      jsonDecode(response.body);

  return data
      .map((e) => Court.fromJson(e))
      .toList();
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
static Future<List<Court>> fetchCourtsByLocation(int locationId) async {
  final response = await ApiClient.get(
    '/locations/$locationId/courts',
    auth: true,
  );

  print('STATUS = ${response.statusCode}');
  print('BODY = ${response.body}');

  final List<dynamic> data = jsonDecode(response.body);

  return data.map((e) => Court.fromJson(e)).toList();
}
}


