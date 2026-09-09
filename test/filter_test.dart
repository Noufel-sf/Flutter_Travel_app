import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/data/repositories/places_repository_impl.dart';
import 'package:flutter_travel_concept/models/filter_criteria.dart';

void main() {
  group('FilterCriteria Model Tests', () {
    test('default criteria has isDefault true and activeFiltersCount 0', () {
      const criteria = FilterCriteria();
      expect(criteria.isDefault, isTrue);
      expect(criteria.activeFiltersCount, 0);
      expect(criteria.minPrice, FilterCriteria.defaultMinPrice);
      expect(criteria.maxPrice, FilterCriteria.defaultMaxPrice);
      expect(criteria.minRating, 0.0);
      expect(criteria.amenities, isEmpty);
      expect(criteria.sortBy, SortOption.recommended);
    });

    test('activeFiltersCount calculates correctly for each active filter', () {
      var criteria = const FilterCriteria(category: 'Beach');
      expect(criteria.activeFiltersCount, 1);

      criteria = criteria.copyWith(priceRange: const RangeValues(60, 250));
      expect(criteria.activeFiltersCount, 2);

      criteria = criteria.copyWith(minRating: 4.0);
      expect(criteria.activeFiltersCount, 3);

      criteria = criteria.copyWith(amenities: {'Spa', 'Gym'});
      // 3 previous filters + 2 amenities = 5
      expect(criteria.activeFiltersCount, 5);

      criteria = criteria.copyWith(sortBy: SortOption.priceLowToHigh);
      expect(criteria.activeFiltersCount, 6);

      expect(criteria.isDefault, isFalse);
    });
  });

  group('PlacesRepositoryImpl Filtering & Sorting Tests', () {
    final repository = PlacesRepositoryImpl();

    test('filters by price range accurately', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(priceRange: RangeValues(100, 200)),
      );
      expect(results, isNotEmpty);
      for (final p in results) {
        expect(p.pricePerNight, greaterThanOrEqualTo(100));
        expect(p.pricePerNight, lessThanOrEqualTo(200));
      }
    });

    test('filters by minimum rating threshold', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(minRating: 4.5),
      );
      expect(results, isNotEmpty);
      for (final p in results) {
        expect(p.rating, greaterThanOrEqualTo(4.5));
      }
    });

    test('filters by specific amenities', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(amenities: {'Spa'}),
      );
      expect(results, isNotEmpty);
      for (final p in results) {
        expect(p.amenities.contains('Spa'), isTrue);
      }
    });

    test('sorts by price low-to-high (priceLowToHigh)', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(sortBy: SortOption.priceLowToHigh),
      );
      expect(results, isNotEmpty);
      for (int i = 0; i < results.length - 1; i++) {
        expect(
          results[i].pricePerNight,
          lessThanOrEqualTo(results[i + 1].pricePerNight),
        );
      }
    });

    test('sorts by price high-to-low (priceHighToLow)', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(sortBy: SortOption.priceHighToLow),
      );
      expect(results, isNotEmpty);
      for (int i = 0; i < results.length - 1; i++) {
        expect(
          results[i].pricePerNight,
          greaterThanOrEqualTo(results[i + 1].pricePerNight),
        );
      }
    });

    test('sorts by rating high-to-low (highestRated)', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(sortBy: SortOption.highestRated),
      );
      expect(results, isNotEmpty);
      for (int i = 0; i < results.length - 1; i++) {
        expect(
          results[i].rating,
          greaterThanOrEqualTo(results[i + 1].rating),
        );
      }
    });

    test('combines search query with filter criteria', () async {
      final results = await repository.applyFilters(
        const FilterCriteria(
          priceRange: RangeValues(40, 200),
          minRating: 4.0,
        ),
        query: 'hotel',
      );
      for (final p in results) {
        expect(
          p.name.toLowerCase().contains('hotel') ||
              p.location.toLowerCase().contains('hotel'),
          isTrue,
        );
        expect(p.pricePerNight, greaterThanOrEqualTo(40));
        expect(p.pricePerNight, lessThanOrEqualTo(200));
        expect(p.rating, greaterThanOrEqualTo(4.0));
      }
    });
  });
}
