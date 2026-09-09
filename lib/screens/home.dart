import 'package:flutter/material.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/util/const.dart';
import 'package:flutter_travel_concept/util/places.dart';
import 'package:flutter_travel_concept/widgets/horizontal_place_item.dart';
import 'package:flutter_travel_concept/widgets/icon_badge.dart';
import 'package:flutter_travel_concept/widgets/search_bar.dart';
import 'package:flutter_travel_concept/widgets/vertical_place_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = "All";

  final List<Map<String, dynamic>> _categoryData = [
    {"name": "All", "label": "Promo", "icon": Icons.local_offer_rounded},
    {"name": "Hotels", "label": "Hotels", "icon": Icons.hotel_rounded},
    {"name": "Beaches", "label": "Beaches", "icon": Icons.beach_access_rounded},
    {"name": "Restaurants", "label": "Dining", "icon": Icons.restaurant_rounded},
    {"name": "Resorts", "label": "Resorts", "icon": Icons.pool_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Place> get _filteredPlaces {
    final query = _searchController.text.trim().toLowerCase();
    return places.where((place) {
      final matchesCategory = _selectedCategory == "All" ||
          place.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = query.isEmpty ||
          place.name.toLowerCase().contains(query) ||
          place.location.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = "All";
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPlaces;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(height: 12.0),

            // Top Header: Location + Notification & Mode Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Location",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Constants.brandBlue,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "Surakarta, Indonesia",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Constants.textDark,
                            ),
                          ),
                          const SizedBox(width: 2.0),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18.0,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Mode Switcher
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeModeNotifier,
                        builder: (context, currentMode, _) {
                          final isDarkMode = currentMode == ThemeMode.dark;
                          return _headerCircleButton(
                            icon: isDarkMode
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_outlined,
                            onTap: () {
                              themeModeNotifier.value = isDarkMode
                                  ? ThemeMode.light
                                  : ThemeMode.dark;
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 10.0),

                      // Notification Bell
                      _headerCircleButton(
                        iconWidget: const IconBadge(
                          icon: Icons.notifications_none_rounded,
                          size: 20.0,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18.0),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomSearchBar(
                controller: _searchController,
                onClear: () => _searchController.clear(),
                onFilterTap: () {
                  _showFilterOptionsModal(context);
                },
              ),
            ),
            const SizedBox(height: 18.0),

            // Category Selector Chips
            buildCategoryChips(),
            const SizedBox(height: 10.0),

            if (filtered.isEmpty)
              buildEmptyState()
            else ...[
              // Section 1: Choice for you (Horizontal Carousel)
              buildSectionHeader("Choice for you", onSeeAll: () {}),
              buildHorizontalList(context, filtered),

              const SizedBox(height: 8.0),

              // Section 2: Popular Destination (Vertical List)
              buildSectionHeader("Popular Destination", onSeeAll: () {}),
              buildVerticalList(filtered),
            ],

            // Bottom space for floating navigation bar
            const SizedBox(height: 90.0),
          ],
        ),
      ),
    );
  }

  Widget _headerCircleButton({
    IconData? icon,
    Widget? iconWidget,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(20.0),
      onTap: onTap,
      child: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8.0,
              offset: const Offset(0, 2.0),
            ),
          ],
        ),
        child: Center(
          child: iconWidget ??
              Icon(
                icon,
                size: 20.0,
                color: isDark ? Colors.white : Constants.textDark,
              ),
        ),
      ),
    );
  }

  Widget buildCategoryChips() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 46.0,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _categoryData.length,
        itemBuilder: (context, index) {
          final item = _categoryData[index];
          final categoryKey = item["name"] as String;
          final label = item["label"] as String;
          final icon = item["icon"] as IconData;
          final isSelected = _selectedCategory == categoryKey;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                setState(() {
                  _selectedCategory = categoryKey;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Constants.brandBlue
                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0)),
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Constants.brandBlue.withValues(alpha: 0.35),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4.0),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 17.0,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? const Color(0xFFF1F5F9)
                                : Constants.textDark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: isDark ? Colors.white : Constants.textDark,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: onSeeAll,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Text(
                "See All",
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: Constants.brandBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Constants.brandBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 56.0,
                color: Constants.brandBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "No destinations found",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Try searching with a different term or category filter.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.blueGrey[400],
              ),
            ),
            const SizedBox(height: 18.0),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Clear Filters"),
              onPressed: _clearFilters,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalList(BuildContext context, List<Place> filtered) {
    return SizedBox(
      height: 235.0,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 20.0),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filtered.length,
        itemBuilder: (BuildContext context, int index) {
          final place = filtered.reversed.toList()[index];
          return HorizontalPlaceItem(place: place);
        },
      ),
    );
  }

  Widget buildVerticalList(List<Place> filtered) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: filtered.length,
        itemBuilder: (BuildContext context, int index) {
          final place = filtered[index];
          return VerticalPlaceItem(place: place);
        },
      ),
    );
  }

  void _showFilterOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Filter Destinations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _categoryData.map((c) {
                  final key = c["name"] as String;
                  final isSelected = _selectedCategory == key;
                  return ChoiceChip(
                    label: Text(c["label"] as String),
                    selected: isSelected,
                    selectedColor: Constants.brandBlue,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Constants.textDark,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (_) {
                      setState(() => _selectedCategory = key);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
