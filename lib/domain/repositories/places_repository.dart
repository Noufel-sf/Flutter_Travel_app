import 'package:flutter_travel_concept/models/filter_criteria.dart';
import 'package:flutter_travel_concept/models/place.dart';

abstract class PlacesRepository {
  /// Fetches all available destinations
  Future<List<Place>> getPlaces();

  /// Searches destinations by query and optional category filter
  Future<List<Place>> searchPlaces(String query, {String? category});

  /// Applies comprehensive multi-criteria filtering and sorting
  Future<List<Place>> applyFilters(FilterCriteria criteria, {String query = ''});

  /// Fetches a single place by its ID
  Future<Place?> getPlaceById(String id);
}
