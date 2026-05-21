import 'motion_detector_service.dart';

/// Detects shake gesture: acceleration > 15 m/s² sustained for ≥ 2 seconds.
class ShakeDetector {
  static const double shakeThreshold = 15.0;  // m/s²
  static const int durationMs = 2000;         // 2 seconds

  DateTime? _shakeStartTime;
  bool _triggered = false;

  /// Returns a [MotionEvent] of type [MotionEventType.shakeGesture] when
  /// the shake threshold has been sustained for ≥ 2 seconds.
  MotionEvent? process(AccelerometerReading reading) {
    final mag = reading.magnitude;

    if (mag > shakeThreshold) {
      _shakeStartTime ??= reading.timestamp;
      final elapsed = reading.timestamp.difference(_shakeStartTime!).inMilliseconds;
      if (elapsed >= durationMs && !_triggered) {
        _triggered = true;
        return MotionEvent(
          type: MotionEventType.shakeGesture,
          peakAcceleration: mag,
          timestamp: reading.timestamp,
        );
      }
    } else {
      // Acceleration dropped below threshold — reset
      _shakeStartTime = null;
      _triggered = false;
    }

    return null;
  }

  void reset() {
    _shakeStartTime = null;
    _triggered = false;
  }
}
