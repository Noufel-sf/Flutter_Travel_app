import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/main.dart';
import 'package:flutter_travel_concept/router/app_router.dart';
import 'package:flutter_travel_concept/screens/boarding_pass_screen.dart';
import 'package:flutter_travel_concept/screens/details.dart';
import 'package:flutter_travel_concept/screens/favorites_screen.dart';
import 'package:flutter_travel_concept/screens/home.dart';
import 'package:flutter_travel_concept/screens/profile_screen.dart';
import 'package:flutter_travel_concept/screens/reviews_screen.dart';
import 'package:flutter_travel_concept/util/places.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('go_router Declarative Navigation Tests', () {
    testWidgets('App starts at root / and renders Home in bottom shell',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('Deep link to /details/1 directly renders Details screen',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      appRouter.go('/details/1');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(Details), findsOneWidget);
      expect(find.text(places.first.name), findsWidgets);
    });

    testWidgets(
        'Deep link to /boarding-pass/TRV-89412 directly renders BoardingPassScreen',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();

      appRouter.go('/boarding-pass/TRV-89412');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(BoardingPassScreen), findsOneWidget);
    });

    testWidgets(
        'Navigating to /favorites, /reviews, /profile switches tabs correctly',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Go to Favorites
      appRouter.go('/favorites');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(FavoritesScreen), findsOneWidget);

      // Go to Reviews
      appRouter.go('/reviews');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ReviewsScreen), findsOneWidget);

      // Go to Profile
      appRouter.go('/profile');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Return to Home
      appRouter.go('/');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
