import 'package:equatable/equatable.dart';
import 'package:flutter_travel_concept/models/place.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state
class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// State emitted while loading saved places from storage
class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

/// State emitted when favorites have been successfully loaded or updated
class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;
  final List<Place> favoritePlaces;

  const FavoritesLoaded({
    required this.favoriteIds,
    required this.favoritePlaces,
  });

  int get count => favoriteIds.length;
  bool isFavorite(String placeId) => favoriteIds.contains(placeId);

  FavoritesLoaded copyWith({
    Set<String>? favoriteIds,
    List<Place>? favoritePlaces,
  }) {
    return FavoritesLoaded(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      favoritePlaces: favoritePlaces ?? this.favoritePlaces,
    );
  }

  @override
  List<Object?> get props => [favoriteIds, favoritePlaces];
}

/// State emitted when an error occurs
class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
