class FranchiseLocation {
  final int id;
  final String name;
  final String city;
  final String latitude;
  final String longitude;

  FranchiseLocation({
    required this.id,
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory FranchiseLocation.fromJson(
    Map<String, dynamic> json,
  ) {
    return FranchiseLocation(
      id: json['id'],
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }
}