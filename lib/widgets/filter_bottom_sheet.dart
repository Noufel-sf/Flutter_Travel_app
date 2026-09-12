import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/filter_criteria.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/haptics.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterCriteria initialCriteria;
  final List<Place> allPlaces;
  final ValueChanged<FilterCriteria> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialCriteria,
    required this.allPlaces,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required FilterCriteria initialCriteria,
    required List<Place> allPlaces,
    required ValueChanged<FilterCriteria> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialCriteria: initialCriteria,
        allPlaces: allPlaces,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterCriteria _criteria;

  static const List<String> _availableAmenities = [
    "Free WiFi",
    "Swimming Pool",
    "Ocean View",
    "Breakfast",
    "Spa",
    "Gym",
    "Fine Dining",
  ];

  @override
  void initState() {
    super.initState();
    _criteria = widget.initialCriteria;
  }

  int get _matchingPlacesCount {
    return widget.allPlaces.where((p) {
      // Category
      if (_criteria.category.isNotEmpty && _criteria.category != 'All') {
        if (p.category.toLowerCase() != _criteria.category.toLowerCase()) {
          return false;
        }
      }
      // Price
      final rate = p.pricePerNight;
      if (rate < _criteria.priceRange.start || rate > _criteria.priceRange.end) {
        return false;
      }
      // Rating
      if (_criteria.minRating > 0 && p.rating < _criteria.minRating) {
        return false;
      }
      // Amenities
      if (_criteria.amenities.isNotEmpty) {
        final hasAll = _criteria.amenities.every((a) => p.amenities.contains(a));
        if (!hasAll) return false;
      }
      return true;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final matchCount = _matchingPlacesCount;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181F2E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12.0),
          Center(
            child: Container(
              height: 4.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 12.0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Filter Places",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: isDark ? Colors.white : Constants.textDark,
                      ),
                    ),
                    if (_criteria.activeFiltersCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: Constants.brandBlueSoft,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          "${_criteria.activeFiltersCount} active",
                          style: const TextStyle(
                            color: Constants.brandBlue,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Haptics.warning();
                    setState(() {
                      _criteria = const FilterCriteria();
                    });
                  },
                  child: const Text(
                    "Reset All",
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF2E384D) : const Color(0xFFF1F5F9),
          ),

          // Scrollable Sections
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Price Range Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price Range Per Night",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark ? Colors.white : Constants.textDark,
                        ),
                      ),
                      Text(
                        "\$${_criteria.priceRange.start.round()} - \$${_criteria.priceRange.end.round()}",
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w800,
                          color: Constants.brandBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  RangeSlider(
                    values: _criteria.priceRange,
                    min: FilterCriteria.defaultMinPrice,
                    max: FilterCriteria.defaultMaxPrice,
                    divisions: 26,
                    activeColor: Constants.brandBlue,
                    inactiveColor: isDark
                        ? const Color(0xFF2E384D)
                        : const Color(0xFFE2E8F0),
                    labels: RangeLabels(
                      "\$${_criteria.priceRange.start.round()}",
                      "\$${_criteria.priceRange.end.round()}",
                    ),
                    onChanged: (vals) {
                      if ((vals.start - _criteria.priceRange.start).abs() >= 15 ||
                          (vals.end - _criteria.priceRange.end).abs() >= 15) {
                        Haptics.selection();
                      }
                      setState(() {
                        _criteria = _criteria.copyWith(priceRange: vals);
                      });
                    },
                  ),
                  const SizedBox(height: 18.0),

                  // 2. Sort Options Section
                  Text(
                    "Sort By",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: SortOption.values.map((sort) {
                      final isSelected = _criteria.sortBy == sort;
                      return ChoiceChip(
                        label: Text(sort.label),
                        selected: isSelected,
                        selectedColor: Constants.brandBlue,
                        backgroundColor: isDark
                            ? const Color(0xFF1E2430)
                            : const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                    ? const Color(0xFF2E384D)
                                    : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : Constants.textLight),
                        ),
                        onSelected: (_) {
                          Haptics.selection();
                          setState(() {
                            _criteria = _criteria.copyWith(sortBy: sort);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22.0),

                  // 3. Minimum Rating Section
                  Text(
                    "Minimum Rating",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [0.0, 4.0, 4.5, 4.8].map((r) {
                      final isSelected = _criteria.minRating == r;
                      final label = r == 0.0 ? "Any Rating" : "$r+ ⭐";
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        selectedColor: Constants.brandBlue,
                        backgroundColor: isDark
                            ? const Color(0xFF1E2430)
                            : const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                    ? const Color(0xFF2E384D)
                                    : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : Constants.textLight),
                        ),
                        onSelected: (_) {
                          Haptics.selection();
                          setState(() {
                            _criteria = _criteria.copyWith(minRating: r);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22.0),

                  // 4. Amenities Section
                  Text(
                    "Amenities",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark ? Colors.white : Constants.textDark,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _availableAmenities.map((amenity) {
                      final isSelected =
                          _criteria.amenities.contains(amenity);
                      return FilterChip(
                        label: Text(amenity),
                        selected: isSelected,
                        showCheckmark: isSelected,
                        checkmarkColor: Colors.white,
                        selectedColor: Constants.brandBlue,
                        backgroundColor: isDark
                            ? const Color(0xFF1E2430)
                            : const Color(0xFFF8FAFC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          side: BorderSide(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                    ? const Color(0xFF2E384D)
                                    : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : Constants.textLight),
                        ),
                        onSelected: (selected) {
                          Haptics.selection();
                          final newSet = Set<String>.from(_criteria.amenities);
                          if (selected) {
                            newSet.add(amenity);
                          } else {
                            newSet.remove(amenity);
                          }
                          setState(() {
                            _criteria = _criteria.copyWith(amenities: newSet);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Apply Button
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0 + bottomInset),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2430) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? const Color(0xFF2E384D)
                      : const Color(0xFFE8EEF8),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.brandBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  Haptics.medium();
                  widget.onApply(_criteria);
                  Navigator.pop(context);
                },
                child: Text(
                  matchCount > 0
                      ? "Show $matchCount Destination${matchCount > 1 ? 's' : ''}"
                      : "No Places Match (Show All)",
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
