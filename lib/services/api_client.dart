import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Ganti sesuai environment:
  // Android emulator → 'http://10.0.2.2:8000/api'
  // iOS sim / web    → 'http://127.0.0.1:8000/api'
  // Device fisik     → 'http://<IP_LAN>:8000/api'
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  // static const String baseUrl = 'http://10.0.2.2:8000/api';

  // ── Token & user storage ─────────────────────────────────────────────────────

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_user_name');
  }

  static Future<void> saveUserInfo(int id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('auth_user_id', id);
    await prefs.setString('auth_user_name', name);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('auth_user_id');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_user_name');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Headers ──────────────────────────────────────────────────────────────────

  static Future<Map<String, String>> _authHeaders({bool auth = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ── HTTP methods ─────────────────────────────────────────────────────────────

  static Future<http.Response> get(String path, {bool auth = false}) async {
    return http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(auth: auth),
    );
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(auth: auth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    return http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(auth: auth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path, {bool auth = false}) async {
    return http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _authHeaders(auth: auth),
    );
  }
}
