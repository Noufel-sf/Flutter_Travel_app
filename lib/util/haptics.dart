import 'package:flutter/services.dart';

/// Enterprise Haptic Feedback Service
/// Provides subtle, consistent, and safe tactile micro-feedback across the app.
/// Gracefully handles platforms where haptic feedback is unsupported (e.g. web/desktop).
class Haptics {
  /// Subtle feedback for tab clicks, chip selections, and quick toggles
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignored on unsupported platforms
    }
  }

  /// Click feedback for sliders, star ratings, and checkboxes
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Ignored on unsupported platforms
    }
  }

  /// Medium feedback for modal popups, filter sheets, and ticket opening
  static Future<void> medium() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Ignored on unsupported platforms
    }
  }

  /// Success feedback for booking completions and wallet saves
  static Future<void> success() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 90));
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignored on unsupported platforms
    }
  }

  /// Warning / destructive feedback for cancel actions, unbooking, and resets
  static Future<void> warning() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // Ignored on unsupported platforms
    }
  }
}
