import 'package:flutter_travel_concept/data/datasources/favorites_local_datasource.dart';
import 'package:flutter_travel_concept/domain/repositories/favorites_repository.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/util/places.dart' as seed_data;

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;
  final List<Place> _allPlaces;
  final Set<String> _cachedFavoriteIds = {};
  bool _isCacheLoaded = false;

  FavoritesRepositoryImpl({
    FavoritesLocalDataSource? localDataSource,
    List<Place>? places,
  })  : _localDataSource = localDataSource ?? FavoritesLocalDataSourceImpl(),
        _allPlaces = places ?? seed_data.places;

  @override
  Future<Set<String>> getFavoriteIds() async {
    if (!_isCacheLoaded) {
      final ids = await _localDataSource.getFavoriteIds();
      _cachedFavoriteIds.clear();
      _cachedFavoriteIds.addAll(ids);
      _isCacheLoaded = true;
    }
    return Set.unmodifiable(_cachedFavoriteIds);
  }

  @override
  Future<bool> isFavorite(String placeId) async {
    if (!_isCacheLoaded) {
      await getFavoriteIds();
    }
    return _cachedFavoriteIds.contains(placeId);
  }

  @override
  Future<bool> toggleFavorite(String placeId) async {
    if (!_isCacheLoaded) {
      await getFavoriteIds();
    }

    final willBeFavorite = !_cachedFavoriteIds.contains(placeId);
    if (willBeFavorite) {
      _cachedFavoriteIds.add(placeId);
    } else {
      _cachedFavoriteIds.remove(placeId);
    }

    await _localDataSource.saveFavoriteIds(_cachedFavoriteIds);
    return willBeFavorite;
  }

  @override
  List<Place> getFavoritePlaces(Set<String> favoriteIds) {
    return _allPlaces.where((p) => favoriteIds.contains(p.id)).toList();
  }
}
