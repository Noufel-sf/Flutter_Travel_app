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

  int get nights {
    final diff = checkOut.difference(checkIn).inDays;
    return diff > 0 ? diff : 1;
  }

  /// 6-character clean PNR reference for the boarding pass
  String get pnr => id.replaceAll('TRV-', '').toUpperCase();

  /// Deterministic suite/room assignment for display
  String get seatOrRoom {
    final num = (id.hashCode.abs() % 400) + 101;
    return "Suite $num";
  }

  /// Deterministic gate assignment for flight styling
  String get gate {
    final letter = String.fromCharCode(65 + (id.hashCode.abs() % 5)); // A - E
    final num = (id.hashCode.abs() % 24) + 1;
    return "$letter$num";
  }

  /// Flight / Booking service code
  String get serviceCode => "TC-${pnr.padRight(5, '0').substring(0, 5)}";

  /// 3-letter Origin airport/city code
  String get originCode {
    const origins = ['JFK', 'LHR', 'CDG', 'DXB', 'SIN'];
    final idx = id.hashCode.abs() % origins.length;
    return origins[idx];
  }

  /// 3-letter Destination airport/city code inferred from location
  String get destinationCode {
    final loc = "${place.location} ${place.name}".toLowerCase();
    if (loc.contains("bali") || loc.contains("indonesia")) return "DPS";
    if (loc.contains("santorini") || loc.contains("greece")) return "JTR";
    if (loc.contains("maldives")) return "MLE";
    if (loc.contains("switzerland") || loc.contains("zermatt") || loc.contains("alps")) return "ZRH";
    if (loc.contains("tokyo") || loc.contains("japan")) return "HND";
    if (loc.contains("paris") || loc.contains("france")) return "CDG";
    if (loc.contains("london") || loc.contains("uk")) return "LHR";
    if (loc.contains("venice") || loc.contains("italy")) return "VCE";
    if (loc.contains("rio") || loc.contains("brazil")) return "GIG";
    if (loc.contains("bangkok") || loc.contains("thailand")) return "BKK";
    if (loc.contains("new york") || loc.contains("usa")) return "JFK";
    // Fallback: first 3 letters of location name cleaned
    final clean = place.location.replaceAll(RegExp(r'[^a-zA-Z]'), '').toUpperCase();
    return clean.length >= 3 ? clean.substring(0, 3) : "TRV";
  }

  /// Standard verification URL payload embedded in QR code
  String get qrData =>
      "https://travelconcept.app/verify?id=$id&pnr=$pnr&guest=${Uri.encodeComponent(guestName)}&status=CONFIRMED";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place': place.toJson(),
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'guestName': guestName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      checkIn: DateTime.parse(json['checkIn'] as String),
      checkOut: DateTime.parse(json['checkOut'] as String),
      guests: json['guests'] as int? ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      guestName: json['guestName'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
