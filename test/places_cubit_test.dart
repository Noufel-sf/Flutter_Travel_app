import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/data/repositories/places_repository_impl.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/presentation/cubits/places/places_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/places/places_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PlacesCubit cubit;

  const testPlace1 = Place(
    id: "place_1",
    name: "Horison Hotel",
    img: "assets/1.jpeg",
    price: r"$80/night",
    location: "Bali, Indonesia",
    category: "Hotel",
    details: "Luxury hotel in Bali",
  );

  const testPlace2 = Place(
    id: "place_2",
    name: "Kuta Beach Villa",
    img: "assets/2.jpeg",
    price: r"$150/night",
    location: "Kuta, Indonesia",
    category: "Beach",
    details: "Sunny beach villa",
  );

  setUp(() {
    final repo = PlacesRepositoryImpl(places: [testPlace1, testPlace2]);
    cubit = PlacesCubit(repository: repo);
  });

  tearDown(() {
    cubit.close();
  });

  group('PlacesCubit Clean Architecture Tests', () {
    test('initial state loads all places', () async {
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<PlacesLoaded>());
      final loaded = cubit.state as PlacesLoaded;
      expect(loaded.allPlaces.length, 2);
      expect(loaded.filteredPlaces.length, 2);
    });

    test('filterByCategory filters places correctly', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      await cubit.filterByCategory("Beach");
      final loaded = cubit.state as PlacesLoaded;
      expect(loaded.selectedCategory, "Beach");
      expect(loaded.filteredPlaces.length, 1);
      expect(loaded.filteredPlaces.first.name, "Kuta Beach Villa");
    });

    test('search filters places by query', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      await cubit.search("Horison");
      final loaded = cubit.state as PlacesLoaded;
      expect(loaded.filteredPlaces.length, 1);
      expect(loaded.filteredPlaces.first.name, "Horison Hotel");
    });

    test('clearFilters resets selection and search query', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      await cubit.filterByCategory("Beach");
      await cubit.clearFilters();

      final loaded = cubit.state as PlacesLoaded;
      expect(loaded.selectedCategory, "All");
      expect(loaded.searchQuery, "");
      expect(loaded.filteredPlaces.length, 2);
    });
  });
}
