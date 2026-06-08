class Payment {
  final int id;
  final int reservationId;
  final String paymentMethod;
  final int amount;
  final String status;
  final String? transactionId;

  Payment({
    required this.id,
    required this.reservationId,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    this.transactionId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      reservationId: json['reservation_id'],
      paymentMethod: json['payment_method'],
      amount: json['amount'],
      status: json['status'],
      transactionId: json['transaction_id'],
    );
  }
}