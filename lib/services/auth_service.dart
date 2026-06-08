import 'location_service.dart';
import 'dart:convert';
import 'api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiClient.post('/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final token = data['token'] as String;
        final user = data['user'] as Map<String, dynamic>;
        await ApiClient.saveToken(token);
        final position = await LocationService.getCurrentLocation();

if (position != null) {
  await ApiClient.post(
    '/user/location',
    {
      'latitude': position.latitude,
      'longitude': position.longitude,
    },
    auth: true,
  );
}
        await ApiClient.saveUserInfo(user['id'] as int, user['name'] as String);
        return {'success': true, 'user': user};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login gagal',
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiClient.post('/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body) as Map<String, dynamic>;

if (response.statusCode == 200 || response.statusCode == 201) {
  final token = data['token'] as String;
  final user = data['user'] as Map<String, dynamic>;

  // Simpan token dulu
  await ApiClient.saveToken(token);

  // Ambil lokasi dan kirim ke server
  final position = await LocationService.getCurrentLocation();

  if (position != null) {
    await ApiClient.post(
      '/user/location',
      {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      auth: true,
    );
  }

  await ApiClient.saveUserInfo(
    user['id'] as int,
    user['name'] as String,
  );

  return {
    'success': true,
    'user': user,
  };
}

      // Extract validation errors if any
      if (data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        final msg = firstError is List ? firstError.first : firstError.toString();
        return {'success': false, 'message': msg};
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Registrasi gagal',
      };
    } catch (e) {
      return {'success': false, 'message': 'Koneksi gagal: $e'};
    }
  }

  static Future<void> logout() async {
    try {
      await ApiClient.post('/logout', {}, auth: true);
    } catch (_) {}
    await ApiClient.clearToken();
  }
}
