import 'dart:convert';
import 'api_client.dart';
import '../models/user.dart';

class ProfileService {
  /// GET /profile
  static Future<User> fetchProfile() async {
    final response = await ApiClient.get('/profile', auth: true);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(data);
    }

    throw Exception('Gagal memuat profil (${response.statusCode})');
  }

  /// PUT /profile
  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    String? phone,
    double? homeLatitude,
    double? homeLongitude,
  }) async {
    try {
      final body = <String, dynamic>{'name': name};
      if (phone != null) body['phone'] = phone;
      if (homeLatitude != null) body['home_latitude'] = homeLatitude;
      if (homeLongitude != null) body['home_longitude'] = homeLongitude;

      final response = await ApiClient.put('/profile', body, auth: true);
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return {'success': true, 'data': User.fromJson(data['data'])};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Update gagal',
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }
}
