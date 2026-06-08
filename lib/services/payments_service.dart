import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, dynamic>> createPayment({
    required int reservationId,
    required int paymentOptionId,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payments'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'reservation_id': reservationId,
        'payment_option_id': paymentOptionId,
        'amount': amount,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        'success': true,
        'data': data['data'],
      };
    }

    return {
      'success': false,
      'message': data['message'] ?? response.body,
    };
  }
}