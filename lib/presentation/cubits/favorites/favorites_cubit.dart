import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/domain/repositories/favorites_repository.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:flutter_travel_concept/services/favorites_service.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit({required FavoritesRepository repository})
      : _repository = repository,
        super(const FavoritesInitial()) {
    loadFavorites();
  }

  /// Loads favorite place IDs and resolves their entities
  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    try {
      final ids = await _repository.getFavoriteIds();
      final places = _repository.getFavoritePlaces(ids);
      emit(FavoritesLoaded(favoriteIds: ids, favoritePlaces: places));
    } catch (e) {
      emit(FavoritesError("Failed to load saved places: $e"));
    }
  }

  /// Optimistically toggles a place bookmark and persists to repository
  Future<void> toggleFavorite(String placeId) async {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      final currentIds = Set<String>.from(currentState.favoriteIds);
      final isCurrentlyFavorite = currentIds.contains(placeId);

      // Optimistic update
      if (isCurrentlyFavorite) {
        currentIds.remove(placeId);
      } else {
        currentIds.add(placeId);
      }

      final updatedPlaces = _repository.getFavoritePlaces(currentIds);
      emit(FavoritesLoaded(
        favoriteIds: currentIds,
        favoritePlaces: updatedPlaces,
      ));

      // Persist to underlying storage and sync legacy service
      try {
        await _repository.toggleFavorite(placeId);
        if (favoritesService.isFavorite(placeId) != !isCurrentlyFavorite) {
          favoritesService.toggleFavorite(placeId);
        }
      } catch (e) {
        // Rollback on failure
        emit(currentState);
      }
    } else {
      // If not yet loaded, load and then toggle
      await loadFavorites();
      await toggleFavorite(placeId);
    }
  }

  /// Helper check if a place ID is bookmarked
  bool isFavorite(String placeId) {
    final s = state;
    if (s is FavoritesLoaded) {
      return s.isFavorite(placeId);
    }
    return false;
  }
}
