import 'motion_detector_service.dart';

/// Pure logic class — no platform dependencies.
/// Feed it AccelerometerReading objects and it tells you if a fall occurred.
class FallDetector {
  static const double peakThreshold = 25.0;    // m/s²
  static const double restThreshold = 2.0;     // m/s²
  static const int windowMs = 1000;            // 1 second window

  AccelerometerReading? _peakReading;

  /// Returns a [MotionEvent] of type [MotionEventType.potentialFall] if a fall
  /// is detected, or null otherwise.
  MotionEvent? process(AccelerometerReading reading) {
    final mag = reading.magnitude;

    // Step 1: detect peak acceleration above threshold
    if (mag > peakThreshold) {
      _peakReading = reading;
      return null;
    }

    // Step 2: if we had a peak, check for rapid deceleration below rest threshold
    if (_peakReading != null && mag < restThreshold) {
      final elapsed = reading.timestamp.difference(_peakReading!.timestamp).inMilliseconds;
      if (elapsed <= windowMs) {
        final peak = _peakReading!;
        _peakReading = null; // reset
        return MotionEvent(
          type: MotionEventType.potentialFall,
          peakAcceleration: peak.magnitude,
          timestamp: reading.timestamp,
        );
      } else {
        // Window expired — reset
        _peakReading = null;
      }
    }

    return null;
  }

  void reset() {
    _peakReading = null;
  }
}
