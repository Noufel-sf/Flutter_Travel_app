import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/util/haptics.dart';
import 'package:flutter_travel_concept/widgets/favorites_skeleton.dart';
import 'package:flutter_travel_concept/widgets/place_skeleton.dart';
import 'package:flutter_travel_concept/widgets/reviews_skeleton.dart';
import 'package:flutter_travel_concept/widgets/shimmer_loading.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Haptics Unit Tests', () {
    test('Haptic methods execute safely without throwing', () async {
      // These call Flutter platform services which no-op in tests
      await Haptics.light();
      await Haptics.selection();
      await Haptics.medium();
      await Haptics.success();
      await Haptics.warning();
    });
  });

  group('Shimmer Loading Widget Tests', () {
    testWidgets('ShimmerEffect renders child in light mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: ShimmerEffect(
              child: ShimmerBox(width: 100, height: 20),
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
      expect(find.byType(ShimmerBox), findsOneWidget);

      // Advance animation frames to verify gradient slides smoothly
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('ShimmerEffect renders child in dark mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: ShimmerEffect(
              child: ShimmerBox(width: 120, height: 30, borderRadius: 12.0),
            ),
          ),
        ),
      );

      expect(find.byType(ShimmerEffect), findsOneWidget);
      expect(find.byType(ShimmerBox), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('HorizontalPlaceSkeleton renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HorizontalPlaceSkeleton(),
          ),
        ),
      );

      expect(find.byType(HorizontalPlaceSkeleton), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('VerticalPlaceSkeleton renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerticalPlaceSkeleton(),
          ),
        ),
      );

      expect(find.byType(VerticalPlaceSkeleton), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsOneWidget);
    });

    testWidgets('HomeScreenSkeleton renders multiple skeletons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: HomeScreenSkeleton(),
            ),
          ),
        ),
      );

      expect(find.byType(HomeScreenSkeleton), findsOneWidget);
      expect(find.byType(HorizontalPlaceSkeleton), findsWidgets);
      expect(find.byType(VerticalPlaceSkeleton), findsWidgets);
    });

    testWidgets('FavoritesSkeleton renders skeleton items', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FavoritesSkeleton(),
          ),
        ),
      );

      expect(find.byType(FavoritesSkeleton), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsWidgets);
    });

    testWidgets('ReviewsSkeleton renders review skeletons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReviewsSkeleton(),
          ),
        ),
      );

      expect(find.byType(ReviewsSkeleton), findsOneWidget);
      expect(find.byType(ShimmerEffect), findsWidgets);
    });
  });
}
