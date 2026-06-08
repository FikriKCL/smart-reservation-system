class Court {
  final String id;
  final String name;
  final String location;
  final String tag;
  final int pricePerHour;
  final String picture;
  final double rating;
  final String description;

  Court({
    required this.id,
    required this.name,
    required this.location,
    required this.tag,
    required this.pricePerHour,
    required this.picture,
    required this.rating,
    required this.description,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    return Court(
      id: json['id'].toString(),
      name: json['court_name'] ?? '',
      location: json['location']?['name'] ?? '',
      tag: json['court_type'] ?? 'Padel',
      pricePerHour: json['price_per_hour'] ?? 0,
      picture: json['picture'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      description: json['description'] ?? '',
    );
  }
}