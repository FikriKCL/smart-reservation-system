import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_option.dart';

class PaymentOptionService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<List<PaymentOption>> fetchPaymentOptions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/payment-options'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List data = decoded['data'];

      return data.map((item) {
        return PaymentOption.fromJson(item);
      }).toList();
    }

    throw Exception(
      'Failed to fetch payment options. Status: ${response.statusCode}, Body: ${response.body}',
    );
  }
}