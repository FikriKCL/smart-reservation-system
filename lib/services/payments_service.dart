import 'dart:convert';
import 'api_client.dart';
import '../models/payment.dart';

class PaymentService {
  /// GET /payments
  static Future<List<Payment>> fetchPayments() async {
    final response = await ApiClient.get('/payments', auth: true);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List data =
          decoded is List ? decoded : (decoded['data'] ?? decoded);

      return data
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Gagal memuat pembayaran (${response.statusCode})',
    );
  }

  /// POST /payments
  static Future<Map<String, dynamic>> createPayment({
    required int reservationId,
    required int paymentOptionId,
    required int amount,
  }) async {
    try {
      final response = await ApiClient.post(
        '/payments',
        {
          'reservation_id': reservationId,
          'payment_option_id': paymentOptionId,
          'amount': amount,
        },
        auth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return {
          'success': true,
          'data': data['data'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Pembayaran gagal',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Koneksi gagal: $e',
      };
    }
  }

  /// POST /payments/{id}/pay
  static Future<bool> pay(int paymentId) async {
    final response = await ApiClient.post(
      '/payments/$paymentId/pay',
      {},
      auth: true,
    );

    return response.statusCode == 200;
  }
}