import 'package:flutter_travel_concept/domain/repositories/places_repository.dart';
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
    var result = _places;

    if (category != null && category.isNotEmpty && category != 'All') {
      result = result.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      result = result.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.location.toLowerCase().contains(q) ||
            p.details.toLowerCase().contains(q);
      }).toList();
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
