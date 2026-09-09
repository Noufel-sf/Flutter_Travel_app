import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_travel_concept/models/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewsService extends ChangeNotifier {
  static final ReviewsService _instance = ReviewsService._internal();
  factory ReviewsService() => _instance;
  static ReviewsService get instance => _instance;

  ReviewsService._internal() {
    _loadReviews();
  }

  static const String _storageKey = 'traveler_reviews_data';
  static const String _upvotesKey = 'upvoted_reviews_data';

  final List<Review> _reviews = [];
  final Set<String> _upvotedIds = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  List<Review> get reviews => List.unmodifiable(_reviews);
  int get count => _reviews.length;

  static final List<Review> _initialSeedReviews = [
    Review(
      id: "rev_1",
      placeId: "1",
      placeName: "Hotel Dolah Amet & Suites",
      userName: "Sarah Jenkins",
      rating: 5.0,
      comment:
          "The rooftop suite view over London was unforgettable. Extremely attentive staff and breakfast was 10/10!",
      helpfulCount: 24,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: "rev_2",
      placeId: "2",
      placeName: "Beach Mauris Blandit",
      userName: "Elena Rostova",
      rating: 5.0,
      comment:
          "Sunset walks along the coastline were the highlight of my trip to Lisbon. Don't miss the local seafood nearby.",
      helpfulCount: 19,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Review(
      id: "rev_3",
      placeId: "3",
      placeName: "Ipsum Restaurant",
      userName: "David Chen",
      rating: 4.8,
      comment:
          "Exceptional culinary experience in Paris. The wine pairing was exquisite. Be sure to reserve a table in advance.",
      helpfulCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    Review(
      id: "rev_4",
      placeId: "4",
      placeName: "Curabitur Beach",
      userName: "Sofia Martinez",
      rating: 5.0,
      comment:
          "Crystal clear Mediterranean water and peaceful beach beds. Super easy access from Rome center.",
      helpfulCount: 31,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    Review(
      id: "rev_5",
      placeId: "5",
      placeName: "Tincidunt Pool",
      userName: "Lucas Müller",
      rating: 4.5,
      comment:
          "The infinity pool with Madrid skyline backdrop is simply magical at golden hour. Great lounge music too.",
      helpfulCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  List<Review> getReviewsForPlace(String placeId) {
    return _reviews.where((r) => r.placeId == placeId).toList();
  }

  double getAverageRating(String placeId) {
    final placeReviews = getReviewsForPlace(placeId);
    if (placeReviews.isEmpty) return 4.5;
    final total = placeReviews.map((r) => r.rating).reduce((a, b) => a + b);
    return double.parse((total / placeReviews.length).toStringAsFixed(1));
  }

  bool isUpvoted(String reviewId) => _upvotedIds.contains(reviewId);

  Future<void> _loadReviews() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load upvoted IDs
      final upvotes = prefs.getStringList(_upvotesKey) ?? [];
      _upvotedIds.clear();
      _upvotedIds.addAll(upvotes);

      // Load reviews
      final savedStrings = prefs.getStringList(_storageKey);
      _reviews.clear();

      if (savedStrings == null || savedStrings.isEmpty) {
        _reviews.addAll(_initialSeedReviews);
      } else {
        for (final str in savedStrings) {
          try {
            final map = jsonDecode(str) as Map<String, dynamic>;
            _reviews.add(Review.fromJson(map));
          } catch (e) {
            if (kDebugMode) print("Error parsing review: $e");
          }
        }
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error loading reviews: $e");
      _reviews.clear();
      _reviews.addAll(_initialSeedReviews);
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> addReview(Review review) async {
    _reviews.insert(0, review);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = _reviews.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
    } catch (e) {
      if (kDebugMode) print("Error saving reviews: $e");
    }
  }

  Future<void> toggleHelpful(String reviewId) async {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index == -1) return;

    final review = _reviews[index];
    final isAlreadyUpvoted = _upvotedIds.contains(reviewId);

    if (isAlreadyUpvoted) {
      _upvotedIds.remove(reviewId);
      _reviews[index] = review.copyWith(
        helpfulCount: (review.helpfulCount - 1).clamp(0, 9999),
      );
    } else {
      _upvotedIds.add(reviewId);
      _reviews[index] = review.copyWith(
        helpfulCount: review.helpfulCount + 1,
      );
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_upvotesKey, _upvotedIds.toList());
      final stringList = _reviews.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
    } catch (e) {
      if (kDebugMode) print("Error updating helpful upvote: $e");
    }
  }
}

final reviewsService = ReviewsService.instance;
