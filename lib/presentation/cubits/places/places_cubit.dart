import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/domain/repositories/places_repository.dart';
import 'package:flutter_travel_concept/models/filter_criteria.dart';
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
      final updatedCriteria = currentState.criteria.copyWith(category: category);
      final filtered = await _repository.applyFilters(
        updatedCriteria,
        query: currentState.searchQuery,
      );
      emit(currentState.copyWith(
        selectedCategory: category,
        criteria: updatedCriteria,
        filteredPlaces: filtered,
      ));
    }
  }

  Future<void> search(String query) async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      final filtered = await _repository.applyFilters(
        currentState.criteria,
        query: query,
      );
      emit(currentState.copyWith(
        searchQuery: query,
        filteredPlaces: filtered,
      ));
    }
  }

  Future<void> applyFilters(FilterCriteria newCriteria) async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      final filtered = await _repository.applyFilters(
        newCriteria,
        query: currentState.searchQuery,
      );
      emit(currentState.copyWith(
        criteria: newCriteria,
        selectedCategory: newCriteria.category,
        filteredPlaces: filtered,
      ));
    }
  }

  Future<void> clearFilters() async {
    final currentState = state;
    if (currentState is PlacesLoaded) {
      const defaultCriteria = FilterCriteria();
      emit(currentState.copyWith(
        selectedCategory: 'All',
        searchQuery: '',
        criteria: defaultCriteria,
        filteredPlaces: currentState.allPlaces,
      ));
    }
  }
}
