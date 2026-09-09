class Review {
  final String id;
  final String placeId;
  final String placeName;
  final String userName;
  final double rating;
  final String comment;
  final int helpfulCount;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.userName,
    required this.rating,
    required this.comment,
    this.helpfulCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeId': placeId,
      'placeName': placeName,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      placeId: json['placeId'] as String? ?? '1',
      placeName: json['placeName'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] as String? ?? '',
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Review copyWith({
    String? id,
    String? placeId,
    String? placeName,
    String? userName,
    double? rating,
    String? comment,
    int? helpfulCount,
    DateTime? createdAt,
  }) {
    return Review(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
