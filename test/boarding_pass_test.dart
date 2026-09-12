import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:flutter_travel_concept/models/place.dart';
import 'package:flutter_travel_concept/screens/boarding_pass_screen.dart';
import 'package:flutter_travel_concept/widgets/boarding_pass_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  const testPlace = Place(
    id: '1',
    name: 'Santorini Sunset Villa',
    img: 'assets/1.jpeg',
    price: r'$220/night',
    location: 'Santorini, Greece',
    details: 'Cliffside paradise overlooking Aegean sea.',
  );

  final testBooking = Booking(
    id: 'TRV-89412',
    place: testPlace,
    checkIn: DateTime(2026, 10, 15, 14, 0),
    checkOut: DateTime(2026, 10, 20, 11, 0),
    guests: 2,
    totalPrice: 1100.0,
    guestName: 'Noufel Explorer',
    createdAt: DateTime(2026, 9, 12),
  );

  group('Booking Ticket Getters Tests', () {
    test('PNR extracts clean code from id', () {
      expect(testBooking.pnr, '89412');
    });

    test('destinationCode maps Greece/Santorini to JTR', () {
      expect(testBooking.destinationCode, 'JTR');
    });

    test('gate and seatOrRoom provide formatted strings', () {
      expect(testBooking.gate, isNotEmpty);
      expect(testBooking.seatOrRoom, startsWith('Suite'));
    });

    test('serviceCode has prefix TC-', () {
      expect(testBooking.serviceCode, startsWith('TC-'));
    });

    test('qrData contains verification URL with PNR and guest name', () {
      expect(testBooking.qrData, contains('https://travelconcept.app/verify'));
      expect(testBooking.qrData, contains('pnr=89412'));
      expect(testBooking.qrData, contains('Noufel'));
    });
  });

  group('BoardingPassCard Widget Tests', () {
    testWidgets('Renders all ticket elements and QrImageView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BoardingPassCard(booking: testBooking),
            ),
          ),
        ),
      );

      // Verify header & passenger info
      expect(find.text('TRAVELPASS AIRWAYS'), findsOneWidget);
      expect(find.text('CONFIRMED'), findsOneWidget);
      expect(find.text('Noufel Explorer'), findsOneWidget);
      expect(find.text('JTR'), findsOneWidget);
      expect(find.text('PNR: 89412'), findsOneWidget);

      // Verify QR Code image is rendered
      expect(find.byType(QrImageView), findsOneWidget);
    });
  });

  group('BoardingPassScreen Widget Tests', () {
    testWidgets('Renders screen and handles wallet save interaction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BoardingPassScreen(booking: testBooking),
        ),
      );

      await tester.pumpAndSettle();

      // Check title and actions
      expect(find.text('Digital Boarding Pass'), findsOneWidget);
      expect(find.text('Add to Digital Wallet'), findsOneWidget);
      expect(find.text('Share or Export Ticket'), findsOneWidget);

      // Ensure button is scrolled into view in test viewport
      final walletButton = find.text('Add to Digital Wallet');
      await tester.ensureVisible(walletButton);
      await tester.pumpAndSettle();

      // Tap Save to Wallet
      await tester.tap(walletButton);
      await tester.pump();

      // Verify state changes to Added to Wallet
      expect(find.text('Added to Wallet'), findsOneWidget);
      expect(find.text('Pass for Santorini Sunset Villa added to Digital Wallet!'), findsOneWidget);
    });
  });
}
