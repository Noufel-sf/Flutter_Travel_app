class Place {
  final String id;
  final String name;
  final String img;
  final List<String> images;
  final String price;
  final String location;
  final double rating;
  final String details;

  const Place({
    required this.id,
    required this.name,
    required this.img,
    this.images = const [],
    required this.price,
    required this.location,
    this.rating = 4.5,
    required this.details,
  });

  /// Factory constructor to deserialize from Map/JSON
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] as String? ?? '',
      img: json['img'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['img'] != null ? [json['img'] as String] : const []),
      price: json['price'] as String? ?? r'$0/night',
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      details: json['details'] as String? ?? '',
    );
  }

  /// Serialize to Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'images': images,
      'price': price,
      'location': location,
      'rating': rating,
      'details': details,
    };
  }

  /// CopyWith helper for immutability
  Place copyWith({
    String? id,
    String? name,
    String? img,
    List<String>? images,
    String? price,
    String? location,
    double? rating,
    String? details,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      images: images ?? this.images,
      price: price ?? this.price,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      details: details ?? this.details,
    );
  }
}
