import 'package:flutter_travel_concept/models/place.dart';

class Booking {
  final String id;
  final Place place;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String guestName;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.place,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.guestName,
    required this.createdAt,
  });

  int get nights => checkOut.difference(checkIn).inDays;
}
