import 'dart:convert';
import 'api_client.dart';
import '../models/payment_option.dart';

class PaymentOptionService {
  /// GET /payment-options
  // static Future<List<PaymentOption>> fetchPaymentOptions() async {
  //   final response = await ApiClient.get('/payments-options');

  //   if (response.statusCode == 200) {
  //     final decoded = jsonDecode(response.body) as Map<String, dynamic>;
  //     final List data = decoded['data'] ?? [];
  //     return data
  //         .map((e) => PaymentOption.fromJson(e as Map<String, dynamic>))
  //         .toList();
  //   }

  //   throw Exception(
  //     'Gagal memuat opsi pembayaran (${response.statusCode})',
  //   );
  // }

static Future<List<PaymentOption>> fetchPaymentOptions() async {
  final response = await ApiClient.get('/payments-options');

  print('STATUS = ${response.statusCode}');
  print('BODY = ${response.body}');

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    print('DECODED = $decoded');

    final List data = decoded['data'] ?? [];

    return data
        .map((e) => PaymentOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  throw Exception(
    'Gagal memuat opsi pembayaran (${response.statusCode})',
  );
}

}
