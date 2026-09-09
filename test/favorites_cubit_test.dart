import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/data/datasources/favorites_local_datasource.dart';
import 'package:flutter_travel_concept/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_travel_concept/domain/repositories/favorites_repository.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeFavoritesLocalDataSource implements FavoritesLocalDataSource {
  Set<String> saved = {};

  @override
  Future<Set<String>> getFavoriteIds() async {
    return Set.from(saved);
  }

  @override
  Future<void> saveFavoriteIds(Set<String> favoriteIds) async {
    saved = Set.from(favoriteIds);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFavoritesLocalDataSource fakeDataSource;
  late FavoritesRepository repository;
  late FavoritesCubit cubit;

  const testPlace1 = Place(
    id: "place_1",
    name: "Bali Resort",
    img: "assets/1.jpeg",
    price: r"$120/night",
    location: "Bali, Indonesia",
    details: "Beautiful resort",
  );

  const testPlace2 = Place(
    id: "place_2",
    name: "Mountain Lodge",
    img: "assets/2.jpeg",
    price: r"$80/night",
    location: "Lombok, Indonesia",
    details: "Cozy mountain lodge",
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    fakeDataSource = FakeFavoritesLocalDataSource();
    repository = FavoritesRepositoryImpl(
      localDataSource: fakeDataSource,
      places: [testPlace1, testPlace2],
    );
    cubit = FavoritesCubit(repository: repository);
  });

  tearDown(() {
    cubit.close();
  });

  group('FavoritesCubit Clean Architecture Tests', () {
    test('initial state begins with loading then loaded', () async {
      // Allow async initialization in constructor
      await Future.delayed(const Duration(milliseconds: 50));
      expect(cubit.state, isA<FavoritesLoaded>());
      final loaded = cubit.state as FavoritesLoaded;
      expect(loaded.favoriteIds, isEmpty);
      expect(loaded.favoritePlaces, isEmpty);
    });

    test('toggleFavorite adds place and emits updated FavoritesLoaded state', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      await cubit.toggleFavorite("place_1");

      expect(cubit.state, isA<FavoritesLoaded>());
      final loaded = cubit.state as FavoritesLoaded;
      expect(loaded.isFavorite("place_1"), isTrue);
      expect(loaded.favoritePlaces.length, 1);
      expect(loaded.favoritePlaces.first.id, "place_1");
      expect(cubit.isFavorite("place_1"), isTrue);
    });

    test('toggleFavorite removes place when already bookmarked', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      await cubit.toggleFavorite("place_1");
      expect(cubit.isFavorite("place_1"), isTrue);

      await cubit.toggleFavorite("place_1");
      expect(cubit.isFavorite("place_1"), isFalse);

      final loaded = cubit.state as FavoritesLoaded;
      expect(loaded.favoritePlaces, isEmpty);
    });
  });
}
