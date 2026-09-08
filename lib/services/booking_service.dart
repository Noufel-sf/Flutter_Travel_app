import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_travel_concept/models/booking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingService extends ChangeNotifier {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  static BookingService get instance => _instance;

  BookingService._internal() {
    _loadBookings();
  }

  static const String _storageKey = 'user_bookings_data';
  final List<Booking> _bookings = [];
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  int get count => _bookings.length;
  List<Booking> get bookings => List.unmodifiable(_bookings);

  Future<void> _loadBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList = prefs.getStringList(_storageKey) ?? [];
      _bookings.clear();
      for (final str in stringList) {
        try {
          final map = jsonDecode(str) as Map<String, dynamic>;
          _bookings.add(Booking.fromJson(map));
        } catch (e) {
          if (kDebugMode) {
            print("Failed to decode booking: $e");
          }
        }
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading bookings: $e");
      }
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.insert(0, booking); // Most recent first
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList =
          _bookings.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving booking: $e");
      }
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) return false;

    _bookings.removeAt(index);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final stringList =
          _bookings.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList(_storageKey, stringList);
    } catch (e) {
      if (kDebugMode) {
        print("Error updating bookings: $e");
      }
    }
    return true;
  }

  Future<void> clearAllBookings() async {
    _bookings.clear();
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      if (kDebugMode) {
        print("Error clearing bookings: $e");
      }
    }
  }
}

final bookingService = BookingService.instance;
