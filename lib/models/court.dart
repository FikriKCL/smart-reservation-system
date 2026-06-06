class Court {
  final String id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final int reviews;
  final String image;
  final List<String> gallery;
  final String tag;
  final String description;
  final List<String> facilities;
  final String surface;
  final String size;
  final int players;

  const Court({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.image,
    required this.gallery,
    required this.tag,
    required this.description,
    required this.facilities,
    required this.surface,
    required this.size,
    required this.players,
  });
}

class BookingInfo {
  final int date;
  final String time;
  final int players;
  final double total;
  final Court court;

  const BookingInfo({
    required this.date,
    required this.time,
    required this.players,
    required this.total,
    required this.court,
  });
}

const _blue =
    'https://images.pexels.com/photos/32474981/pexels-photo-32474981.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _rest =
    'https://images.pexels.com/photos/35248327/pexels-photo-35248327.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _group =
    'https://images.pexels.com/photos/35248404/pexels-photo-35248404.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _coach =
    'https://images.pexels.com/photos/34399237/pexels-photo-34399237.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _smile =
    'https://images.pexels.com/photos/35248274/pexels-photo-35248274.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _topview =
    'https://images.pexels.com/photos/35646550/pexels-photo-35646550.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _pink =
    'https://images.pexels.com/photos/34285600/pexels-photo-34285600.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';
const _match =
    'https://images.pexels.com/photos/34079998/pexels-photo-34079998.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200';

const List<Court> kCourts = [
  Court(
    id: '1',
    name: 'Smash Arena Court',
    location: 'Downtown, Rome Italy',
    price: 30,
    rating: 4.9,
    reviews: 379,
    image: _blue,
    gallery: [_blue, _topview, _group, _match],
    tag: 'Indoor',
    description:
        'A premium indoor padel court with professional-grade glass walls and crystal blue turf. Perfect lighting and climate control for all-season play with friends.',
    facilities: ['WiFi', 'Parking', 'Showers', 'Cafe', 'Rackets'],
    surface: 'Premium Blue Turf',
    size: '20m x 10m',
    players: 4,
  ),
  Court(
    id: '2',
    name: 'Vibora Club Court',
    location: 'Baghdad Center',
    price: 45,
    rating: 4.8,
    reviews: 512,
    image: _match,
    gallery: [_match, _coach, _group, _blue],
    tag: 'Panoramic',
    description:
        'Panoramic glass court offering an immersive playing experience. Hosted countless tournaments with top-tier facilities and a vibrant community.',
    facilities: ['WiFi', 'Parking', 'Lockers', 'Coach', 'Shop'],
    surface: 'Pro Green Turf',
    size: '20m x 10m',
    players: 4,
  ),
  Court(
    id: '3',
    name: 'Net Point Padel',
    location: 'Marina Bay, Rome',
    price: 40,
    rating: 4.7,
    reviews: 286,
    image: _topview,
    gallery: [_topview, _smile, _pink, _blue],
    tag: 'Outdoor',
    description:
        'Scenic outdoor court by the marina. Feel the breeze while enjoying a competitive match on freshly maintained synthetic grass.',
    facilities: ['Parking', 'Showers', 'Cafe', 'Rackets'],
    surface: 'Synthetic Grass',
    size: '20m x 10m',
    players: 4,
  ),
  Court(
    id: '4',
    name: 'Golden Volley Court',
    location: 'Riverside, Rome Italy',
    price: 50,
    rating: 5.0,
    reviews: 198,
    image: _smile,
    gallery: [_smile, _rest, _coach, _group],
    tag: 'Trending',
    description:
        'Our flagship court with championship lighting and tournament-grade flooring. The favorite among pros and competitive players.',
    facilities: ['WiFi', 'Parking', 'Showers', 'Cafe', 'Coach', 'Shop'],
    surface: 'Tournament Turf',
    size: '20m x 10m',
    players: 4,
  ),
  Court(
    id: '5',
    name: 'Sunset Single Court',
    location: 'Hillview, Rome',
    price: 25,
    rating: 4.6,
    reviews: 142,
    image: _pink,
    gallery: [_pink, _topview, _match, _smile],
    tag: 'Single',
    description:
        'Compact court ideal for one-on-one practice and quick rallies. Affordable and always available for casual players.',
    facilities: ['Parking', 'Rackets', 'Lockers'],
    surface: 'Blue Turf',
    size: '16m x 6m',
    players: 2,
  ),
  Court(
    id: '6',
    name: 'Arena Pro Court',
    location: 'Old Town, Rome',
    price: 35,
    rating: 4.8,
    reviews: 233,
    image: _coach,
    gallery: [_coach, _group, _blue, _match],
    tag: 'Indoor',
    description:
        'Spacious indoor arena with coaching available on-site. Great for group sessions and skill-building clinics.',
    facilities: ['WiFi', 'Parking', 'Showers', 'Coach', 'Cafe'],
    surface: 'Premium Turf',
    size: '20m x 10m',
    players: 4,
  ),
];

const List<String> kFilterTags = [
  'All',
  'Indoor',
  'Outdoor',
  'Panoramic',
  'Trending',
  'Single',
];

const List<String> kFacilityOptions = [
  'WiFi',
  'Parking',
  'Showers',
  'Cafe',
  'Rackets',
  'Coach',
  'Lockers',
  'Shop',
];

const List<String> kTimeSlots = [
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '14:00',
  '15:00',
  '16:00',
  '18:00',
  '19:00',
  '20:00',
];
