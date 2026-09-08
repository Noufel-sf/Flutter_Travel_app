import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/models/place.dart';

void main() {
  group('Booking & Pricing Tests', () {
    const testPlace = Place(
      id: '1',
      name: 'Grand Resort',
      img: 'assets/1.jpeg',
      price: r'$150/night',
      location: 'Miami, USA',
      details: 'Luxury resort.',
    );

    test('Extracts numeric pricePerNight from price string', () {
      expect(testPlace.pricePerNight, 150.0);
    });

    test('Calculates booking duration correctly', () {
      final checkIn = DateTime(2026, 10, 1);
      final checkOut = DateTime(2026, 10, 5);

      final booking = Booking(
        id: 'TRV-12345',
        place: testPlace,
        checkIn: checkIn,
        checkOut: checkOut,
        guests: 3,
        totalPrice: 660.0,
        guestName: 'Noufel',
        createdAt: DateTime.now(),
      );

      expect(booking.nights, 4);
      expect(booking.totalPrice, 660.0);
      expect(booking.guests, 3);
    });
  });
}
