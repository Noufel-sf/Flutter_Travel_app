import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/services/booking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookingService State & Persistence Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    const testPlace = Place(
      id: '99',
      name: 'Santorini Sunset Villa',
      img: 'assets/1.jpeg',
      price: r'$200/night',
      location: 'Santorini, Greece',
      details: 'Luxury cliffside villa.',
    );

    test('Adds and cancels bookings properly', () async {
      final service = BookingService.instance;
      await service.clearAllBookings();

      expect(service.count, 0);

      final booking = Booking(
        id: 'TRV-99999',
        place: testPlace,
        checkIn: DateTime.now(),
        checkOut: DateTime.now().add(const Duration(days: 3)),
        guests: 2,
        totalPrice: 660.0,
        guestName: 'Noufel Test',
        createdAt: DateTime.now(),
      );

      await service.addBooking(booking);
      expect(service.count, 1);
      expect(service.bookings.first.id, 'TRV-99999');

      final cancelled = await service.cancelBooking('TRV-99999');
      expect(cancelled, isTrue);
      expect(service.count, 0);
    });
  });
}
