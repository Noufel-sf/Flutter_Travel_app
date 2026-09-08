import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/services/favorites_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'favorite_place_ids': ['1'],
      });
    });

    test('Loads initial favorites correctly and toggles state', () async {
      final service = FavoritesService.instance;
      // Wait for async load if needed
      await Future.delayed(const Duration(milliseconds: 50));

      expect(service.isFavorite('1'), isTrue);

      // Toggle off
      final isNowFavorite = await service.toggleFavorite('1');
      expect(isNowFavorite, isFalse);
      expect(service.isFavorite('1'), isFalse);

      // Toggle on
      final isFavoriteAgain = await service.toggleFavorite('1');
      expect(isFavoriteAgain, isTrue);
      expect(service.isFavorite('1'), isTrue);
      expect(service.count, greaterThanOrEqualTo(1));
    });
  });
}
