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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] as String?,
      homeLatitude: (json['home_latitude'] as num?)?.toDouble(),
      homeLongitude: (json['home_longitude'] as num?)?.toDouble(),
      reservationCount: json['reservation_count'] ?? 0,
      waitingListCount: json['waiting_list_count'] ?? 0,
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
