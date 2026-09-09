import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/domain/repositories/places_repository.dart';
import 'package:flutter_travel_concept/presentation/cubits/places/places_state.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlacesRepository _repository;

  PlacesCubit({required PlacesRepository repository})
      : _repository = repository,
        super(const PlacesInitial()) {
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    emit(const PlacesLoading());
    try {
      final places = await _repository.getPlaces();
      emit(PlacesLoaded(allPlaces: places, filteredPlaces: places));
    } catch (e) {
      emit(PlacesError("Failed to fetch places: $e"));
    }
  }

  Future<void> filterByCategory(String category) async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      final filtered = await _repository.searchPlaces(
        currentState.searchQuery,
        category: category,
      );
      emit(currentState.copyWith(
        selectedCategory: category,
        filteredPlaces: filtered,
      ));
    }
  }

  Future<void> search(String query) async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      final filtered = await _repository.searchPlaces(
        query,
        category: currentState.selectedCategory,
      );
      emit(currentState.copyWith(
        searchQuery: query,
        filteredPlaces: filtered,
      ));
    }
  }

  Future<void> clearFilters() async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      emit(currentState.copyWith(
        selectedCategory: 'All',
        searchQuery: '',
        filteredPlaces: currentState.allPlaces,
      ));
    }
  }
}
