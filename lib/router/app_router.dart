import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/screens/boarding_pass_screen.dart';
import 'package:flutter_travel_concept/screens/details.dart';
import 'package:flutter_travel_concept/screens/favorites_screen.dart';
import 'package:flutter_travel_concept/screens/home.dart';
import 'package:flutter_travel_concept/screens/main_screen.dart';
import 'package:flutter_travel_concept/screens/profile_screen.dart';
import 'package:flutter_travel_concept/screens/reviews_screen.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:flutter_travel_concept/util/places.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Persistent Bottom Navigation Shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Home(),
            ),
          ],
        ),

        // Tab 1: Favorites
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              builder: (context, state) => FavoritesScreen(
                onExploreTap: () => context.go('/'),
              ),
            ),
          ],
        ),

        // Tab 2: Reviews
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reviews',
              name: 'reviews',
              builder: (context, state) => ReviewsScreen(
                onExploreTap: () => context.go('/'),
              ),
            ),
          ],
        ),

        // Tab 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => ProfileScreen(
                onExploreTap: () => context.go('/'),
              ),
            ),
          ],
        ),
      ],
    ),

    // Top-Level Screen: Place Details (Overlays bottom navigation)
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/details/:id',
      name: 'details',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '1';
        final extraPlace = state.extra as Place?;
        final place = extraPlace ??
            places.firstWhere(
              (p) => p.id == id,
              orElse: () => places.first,
            );
        return Details(place: place);
      },
    ),

    // Top-Level Screen: Digital Boarding Pass & QR Code
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/boarding-pass/:id',
      name: 'boarding-pass',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final extraBooking = state.extra as Booking?;
        final booking = extraBooking ??
            bookingService.bookings.firstWhere(
              (b) => b.id == id,
              orElse: () => bookingService.bookings.isNotEmpty
                  ? bookingService.bookings.first
                  : Booking(
                      id: id.isNotEmpty ? id : 'TRV-89412',
                      place: places.first,
                      checkIn: DateTime.now().add(const Duration(days: 7)),
                      checkOut: DateTime.now().add(const Duration(days: 12)),
                      guests: 2,
                      totalPrice: 1100.0,
                      guestName: 'Noufel Explorer',
                      createdAt: DateTime.now(),
                    ),
            );
        return BoardingPassScreen(booking: booking);
      },
    ),
  ],
);
