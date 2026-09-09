import 'package:flutter/material.dart';

enum SortOption {
  recommended,
  priceLowToHigh,
  priceHighToLow,
  highestRated,
}

extension SortOptionExt on SortOption {
  String get label {
    switch (this) {
      case SortOption.recommended:
        return "Recommended";
      case SortOption.priceLowToHigh:
        return "Price: Low to High";
      case SortOption.priceHighToLow:
        return "Price: High to Low";
      case SortOption.highestRated:
        return "Highest Rated";
    }
  }
}

class FilterCriteria {
  final RangeValues priceRange;
  final double minRating;
  final String category;
  final Set<String> amenities;
  final SortOption sortBy;

  static const double defaultMinPrice = 40.0;
  static const double defaultMaxPrice = 300.0;

  const FilterCriteria({
    this.priceRange = const RangeValues(defaultMinPrice, defaultMaxPrice),
    this.minRating = 0.0,
    this.category = 'All',
    this.amenities = const {},
    this.sortBy = SortOption.recommended,
  });

  double get minPrice => priceRange.start;
  double get maxPrice => priceRange.end;

  bool get isDefault =>
      priceRange.start == defaultMinPrice &&
      priceRange.end == defaultMaxPrice &&
      minRating == 0.0 &&
      category == 'All' &&
      amenities.isEmpty &&
      sortBy == SortOption.recommended;

  int get activeFiltersCount {
    int count = 0;
    if (priceRange.start > defaultMinPrice || priceRange.end < defaultMaxPrice) {
      count++;
    }
    if (minRating > 0.0) count++;
    if (category != 'All') count++;
    if (amenities.isNotEmpty) count += amenities.length;
    if (sortBy != SortOption.recommended) count++;
    return count;
  }

  FilterCriteria copyWith({
    RangeValues? priceRange,
    double? minRating,
    String? category,
    Set<String>? amenities,
    SortOption? sortBy,
  }) {
    return FilterCriteria(
      priceRange: priceRange ?? this.priceRange,
      minRating: minRating ?? this.minRating,
      category: category ?? this.category,
      amenities: amenities ?? this.amenities,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
