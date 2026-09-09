import 'package:equatable/equatable.dart';
import 'package:flutter_travel_concept/models/filter_criteria.dart';
import 'package:flutter_travel_concept/models/place.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object?> get props => [];
}

class PlacesInitial extends PlacesState {
  const PlacesInitial();
}

class PlacesLoading extends PlacesState {
  const PlacesLoading();
}

class PlacesLoaded extends PlacesState {
  final List<Place> allPlaces;
  final List<Place> filteredPlaces;
  final String selectedCategory;
  final String searchQuery;
  final FilterCriteria criteria;

  const PlacesLoaded({
    required this.allPlaces,
    required this.filteredPlaces,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.criteria = const FilterCriteria(),
  });

  PlacesLoaded copyWith({
    List<Place>? allPlaces,
    List<Place>? filteredPlaces,
    String? selectedCategory,
    String? searchQuery,
    FilterCriteria? criteria,
  }) {
    return PlacesLoaded(
      allPlaces: allPlaces ?? this.allPlaces,
      filteredPlaces: filteredPlaces ?? this.filteredPlaces,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      criteria: criteria ?? this.criteria,
    );
  }

  @override
  List<Object?> get props => [
        allPlaces,
        filteredPlaces,
        selectedCategory,
        searchQuery,
        criteria,
      ];
}

class PlacesError extends PlacesState {
  final String message;

  const PlacesError(this.message);

  @override
  List<Object?> get props => [message];
}
