class Place {
  final String id;
  final String name;
  final String img;
  final List<String> images;
  final String price;
  final String location;
  final String category;
  final double rating;
  final String details;
  final List<String> amenities;

  const Place({
    required this.id,
    required this.name,
    required this.img,
    this.images = const [],
    required this.price,
    required this.location,
    this.category = 'Hotel',
    this.rating = 4.5,
    required this.details,
    this.amenities = const ['Free WiFi', 'Swimming Pool', 'Breakfast'],
  });

  /// Extracts numeric rate for calculations, e.g. "$100/night" -> 100.0
  double get pricePerNight {
    final clean = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 100.0;
  }

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
      category: json['category'] as String? ?? 'Hotel',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      details: json['details'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['Free WiFi', 'Swimming Pool', 'Breakfast'],
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
      'category': category,
      'rating': rating,
      'details': details,
      'amenities': amenities,
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
    String? category,
    double? rating,
    String? details,
    List<String>? amenities,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      img: img ?? this.img,
      images: images ?? this.images,
      price: price ?? this.price,
      location: location ?? this.location,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      details: details ?? this.details,
      amenities: amenities ?? this.amenities,
    );
  }
}
