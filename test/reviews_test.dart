import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/review.dart';
import 'package:flutter_travel_concept/services/reviews_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ReviewsService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Initializes with seed reviews and filters by place', () async {
      final service = ReviewsService.instance;
      await Future.delayed(const Duration(milliseconds: 50));

      expect(service.reviews.isNotEmpty, isTrue);

      final hotelReviews = service.getReviewsForPlace('1');
      expect(hotelReviews.isNotEmpty, isTrue);
      expect(hotelReviews.first.placeId, '1');
    });

    test('Adds new review and persists state', () async {
      final service = ReviewsService.instance;

      final newReview = Review(
        id: 'test_rev_100',
        placeId: '2',
        placeName: 'Beach Mauris',
        userName: 'Test Traveler',
        rating: 5.0,
        comment: 'Absolutely spectacular coastal views.',
        createdAt: DateTime.now(),
      );

      final initialCount = service.count;
      await service.addReview(newReview);

      expect(service.count, initialCount + 1);
      expect(service.reviews.first.id, 'test_rev_100');
    });

    test('Toggles helpful upvote count', () async {
      final service = ReviewsService.instance;
      final targetReviewId = service.reviews.first.id;
      final initialHelpful = service.reviews.first.helpfulCount;

      // Upvote
      await service.toggleHelpful(targetReviewId);
      expect(service.isUpvoted(targetReviewId), isTrue);
      expect(service.reviews.first.helpfulCount, initialHelpful + 1);

      // Downvote / Undo upvote
      await service.toggleHelpful(targetReviewId);
      expect(service.isUpvoted(targetReviewId), isFalse);
      expect(service.reviews.first.helpfulCount, initialHelpful);
    });
  });
}
