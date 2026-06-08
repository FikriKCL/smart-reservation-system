// import 'dart:convert';
// import 'api_client.dart';
// import '../models/payment.dart';

// class PaymentService {
//   /// GET /payments
//   static Future<List<Payment>> fetchPayments() async {
//     final response = await ApiClient.get('/payments', auth: true);

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final List data = decoded is List ? decoded : (decoded['data'] ?? decoded);
//       return data.map((e) => Payment.fromJson(e as Map<String, dynamic>)).toList();
//     }

//     throw Exception('Gagal memuat pembayaran (${response.statusCode})');
//   }

//   /// POST /payments/{id}/pay
//   static Future<bool> pay(int paymentId) async {
//     final response = await ApiClient.post(
//       '/payments/$paymentId/pay',
//       {},
//       auth: true,
//     );
//     return response.statusCode == 200;
//   }
// }
