import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesLocalDataSource {
  Future<Set<String>> getFavoriteIds();
  Future<void> saveFavoriteIds(Set<String> favoriteIds);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _storageKey = 'favorite_place_ids';
  final SharedPreferences? _prefs;

  FavoritesLocalDataSourceImpl({SharedPreferences? prefs}) : _prefs = prefs;

  Future<SharedPreferences> _getPrefs() async {
    return _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  Future<Set<String>> getFavoriteIds() async {
    final prefs = await _getPrefs();
    final list = prefs.getStringList(_storageKey) ?? [];
    return list.toSet();
  }

  @override
  Future<void> saveFavoriteIds(Set<String> favoriteIds) async {
    final prefs = await _getPrefs();
    await prefs.setStringList(_storageKey, favoriteIds.toList());
  }
}
