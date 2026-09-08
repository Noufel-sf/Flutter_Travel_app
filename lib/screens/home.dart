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
  final List<String> _categories = [
    "All",
    "Hotels",
    "Beaches",
    "Restaurants",
    "Resorts"
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

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, currentMode, _) {
              final isDark = currentMode == ThemeMode.dark;
              return IconButton(
                tooltip:
                    isDark ? "Switch to White Mode" : "Switch to Dark Mode",
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode_outlined,
                ),
                onPressed: () {
                  themeModeNotifier.value =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
          IconButton(
            icon: const IconBadge(
              icon: Icons.notifications_none,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Where are you \ngoing?",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomSearchBar(
              controller: _searchController,
              onClear: () {
                _searchController.clear();
              },
            ),
          ),
          const SizedBox(height: 16.0),
          buildCategoryChips(),
          const SizedBox(height: 10.0),
          if (filtered.isEmpty)
            buildEmptyState()
          else ...[
            buildSectionHeader("Popular Destinations", filtered.length),
            buildHorizontalList(context, filtered),
            buildSectionHeader("All Locations", filtered.length),
            buildVerticalList(filtered),
          ],
        ],
      ),
    );
  }

  Widget buildCategoryChips() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 42.0,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              showCheckmark: false,
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? Colors.white70 : Colors.blueGrey[700]),
              ),
              selectedColor: isDark ? Colors.white : const Color(0xFF263238),
              backgroundColor:
                  isDark ? const Color(0xFF1E1E1E) : Colors.blueGrey[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? Colors.white12 : Colors.black12),
                ),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$count places",
            style: TextStyle(
              fontSize: 13.0,
              color: Colors.blueGrey[400],
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
            Icon(
              Icons.search_off_rounded,
              size: 64.0,
              color: Colors.blueGrey[300],
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
            const SizedBox(height: 16.0),
            OutlinedButton.icon(
              icon: const Icon(Icons.refresh),
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
      height: 260.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
        scrollDirection: Axis.horizontal,
        primary: false,
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
      padding: const EdgeInsets.all(20.0),
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
}
