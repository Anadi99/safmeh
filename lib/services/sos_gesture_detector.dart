import '../models/sos_event.dart';

enum VolumeButtonEvent { up, down }

/// Pure logic SOS gesture detector.
/// Platform channels feed events into this class; it decides when to trigger SOS.
class SosGestureDetector {
  // Power button: 3 presses within 2 seconds
  static const int powerButtonCount = 3;
  static const int powerButtonWindowMs = 2000;

  // Volume pattern: up-up-down within 3 seconds
  static const int volumePatternWindowMs = 3000;

  final List<DateTime> _powerButtonPresses = [];
  final List<(VolumeButtonEvent, DateTime)> _volumeEvents = [];

  /// Call when the power button is pressed.
  /// Returns [SosTrigger.powerButton] if the gesture is detected, null otherwise.
  SosTrigger? onPowerButtonPress(DateTime pressedAt) {
    _powerButtonPresses.add(pressedAt);

    // Remove presses outside the 2-second window
    _powerButtonPresses.removeWhere(
      (t) => pressedAt.difference(t).inMilliseconds > powerButtonWindowMs,
    );

    if (_powerButtonPresses.length >= powerButtonCount) {
      _powerButtonPresses.clear();
      return SosTrigger.powerButton;
    }
    return null;
  }

  /// Call when a volume button is pressed.
  /// Returns [SosTrigger.volumePattern] if up-up-down is detected within 3s.
  SosTrigger? onVolumeButtonPress(VolumeButtonEvent event, DateTime pressedAt) {
    _volumeEvents.add((event, pressedAt));

    // Remove events outside the 3-second window
    _volumeEvents.removeWhere(
      (e) => pressedAt.difference(e.$2).inMilliseconds > volumePatternWindowMs,
    );

    // Check for up-up-down pattern
    if (_volumeEvents.length >= 3) {
      final last3 = _volumeEvents.sublist(_volumeEvents.length - 3);
      if (last3[0].$1 == VolumeButtonEvent.up &&
          last3[1].$1 == VolumeButtonEvent.up &&
          last3[2].$1 == VolumeButtonEvent.down) {
        _volumeEvents.clear();
        return SosTrigger.volumePattern;
      }
    }
    return null;
  }

  /// Reset all gesture state.
  void reset() {
    _powerButtonPresses.clear();
    _volumeEvents.clear();
  }
}
