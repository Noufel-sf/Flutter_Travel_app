import 'package:flutter/foundation.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/util/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  static FavoritesService get instance => _instance;

  FavoritesService._internal() {
    _loadFavorites();
  }

  static const String _storageKey = 'favorite_place_ids';
  final Set<String> _favoriteIds = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  int get count => _favoriteIds.length;
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  List<Place> get favoritePlaces {
    return places.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  bool isFavorite(String placeId) {
    return _favoriteIds.contains(placeId);
  }

  Future<void> _loadFavorites() {
    return SharedPreferences.getInstance().then((prefs) {
      final savedList = prefs.getStringList(_storageKey) ?? [];
      _favoriteIds.clear();
      _favoriteIds.addAll(savedList);
      _isInitialized = true;
      notifyListeners();
    }).catchError((e) {
      if (kDebugMode) {
        print('Error loading favorites: $e');
      }
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<bool> toggleFavorite(String placeId) async {
    final willBeFavorite = !_favoriteIds.contains(placeId);

    if (willBeFavorite) {
      _favoriteIds.add(placeId);
    } else {
      _favoriteIds.remove(placeId);
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_storageKey, _favoriteIds.toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error persisting favorites: $e');
      }
    }

    return willBeFavorite;
  }

  Future<void> clearAllFavorites() async {
    _favoriteIds.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing favorites: $e');
      }
    }
  }
}

final favoritesService = FavoritesService.instance;
