class PaymentOption {
  final int id;
  final String label;
  final String value;
  final String icon;
  final String status;

  PaymentOption({
    required this.id,
    required this.label,
    required this.value,
    required this.icon,
    required this.status,
  });

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? 'payment',
      status: json['status'] ?? 'active',
    );
  }
}