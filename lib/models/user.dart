class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final double? homeLatitude;
  final double? homeLongitude;
  final int reservationCount;
  final int waitingListCount;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.homeLatitude,
    this.homeLongitude,
    this.reservationCount = 0,
    this.waitingListCount = 0,
  });

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString(),
      homeLatitude: _toDouble(json['home_latitude']),
      homeLongitude: _toDouble(json['home_longitude']),
      reservationCount: _toInt(json['reservation_count']),
      waitingListCount: _toInt(json['waiting_list_count']),
    );
  }

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
