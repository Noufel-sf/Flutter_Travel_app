import 'package:flutter_travel_concept/models/place.dart';

abstract class FavoritesRepository {
  /// Returns set of all saved place IDs
  Future<Set<String>> getFavoriteIds();

  /// Toggles favorite status for a given place ID. Returns true if place is now favorite.
  Future<bool> toggleFavorite(String placeId);

  /// Checks if a place is currently bookmarked
  Future<bool> isFavorite(String placeId);

  /// Resolves the list of Place entities for the given saved IDs
  List<Place> getFavoritePlaces(Set<String> favoriteIds);
}
