import 'package:flutter_travel_concept/domain/repositories/places_repository.dart';
import 'package:flutter_travel_concept/models/filter_criteria.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/util/places.dart' as seed_data;

class PlacesRepositoryImpl implements PlacesRepository {
  final List<Place> _places;

  PlacesRepositoryImpl({List<Place>? places})
      : _places = places ?? seed_data.places;

  @override
  Future<List<Place>> getPlaces() async {
    // Simulates an asynchronous data fetch (e.g. from local DB or REST API)
    return List.unmodifiable(_places);
  }

  @override
  Future<List<Place>> searchPlaces(String query, {String? category}) async {
    return applyFilters(
      FilterCriteria(category: category ?? 'All'),
      query: query,
    );
  }

  @override
  Future<List<Place>> applyFilters(FilterCriteria criteria, {String query = ''}) async {
    var result = List<Place>.from(_places);

    // 1. Category Filter
    if (criteria.category.isNotEmpty && criteria.category.toLowerCase() != 'all') {
      result = result
          .where((p) => p.category.toLowerCase() == criteria.category.toLowerCase())
          .toList();
    }

    // 2. Keyword Query Search
    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q) ||
            p.details.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Price Range Filter
    result = result.where((p) {
      final rate = p.pricePerNight;
      return rate >= criteria.priceRange.start && rate <= criteria.priceRange.end;
    }).toList();

    // 4. Minimum Rating Filter
    if (criteria.minRating > 0.0) {
      result = result.where((p) => p.rating >= criteria.minRating).toList();
    }

    // 5. Amenities Multi-tag Filter
    if (criteria.amenities.isNotEmpty) {
      result = result.where((p) {
        return criteria.amenities.every((tag) => p.amenities.contains(tag));
      }).toList();
    }

    // 6. Sorting Order
    switch (criteria.sortBy) {
      case SortOption.priceLowToHigh:
        result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case SortOption.priceHighToLow:
        result.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case SortOption.highestRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.recommended:
        // Preserves default list order
        break;
    }

    return List.unmodifiable(result);
  }

  @override
  Future<Place?> getPlaceById(String id) async {
    try {
      return _places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
