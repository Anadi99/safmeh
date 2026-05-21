import 'motion_detector_service.dart';
import 'fall_detector.dart';
import 'shake_detector.dart';
import 'sos_gesture_detector.dart';

/// Processes sensor readings in a background isolate.
/// Combines fall detection, shake detection, and SOS gesture detection.
class BackgroundSensorProcessor {
  final FallDetector _fallDetector = FallDetector();
  final ShakeDetector _shakeDetector = ShakeDetector();
  final SosGestureDetector _sosGestureDetector = SosGestureDetector();

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  void start() {
    _isRunning = true;
    _fallDetector.reset();
    _shakeDetector.reset();
    _sosGestureDetector.reset();
  }

  void stop() {
    _isRunning = false;
    _fallDetector.reset();
    _shakeDetector.reset();
    _sosGestureDetector.reset();
  }

  /// Process an accelerometer reading.
  /// Returns a [SensorProcessingResult] with any detected events.
  SensorProcessingResult processAccelerometer(AccelerometerReading reading) {
    if (!_isRunning) return const SensorProcessingResult();

    final fallEvent = _fallDetector.process(reading);
    final shakeEvent = _shakeDetector.process(reading);

    return SensorProcessingResult(
      fallEvent: fallEvent,
      shakeEvent: shakeEvent,
    );
  }

  /// Process a power button press event.
  SensorProcessingResult processPowerButtonPress(DateTime pressedAt) {
    if (!_isRunning) return const SensorProcessingResult();
    final trigger = _sosGestureDetector.onPowerButtonPress(pressedAt);
    return SensorProcessingResult(sosTrigger: trigger);
  }

  /// Process a volume button press event.
  SensorProcessingResult processVolumeButtonPress(
    VolumeButtonEvent event,
    DateTime pressedAt,
  ) {
    if (!_isRunning) return const SensorProcessingResult();
    final trigger = _sosGestureDetector.onVolumeButtonPress(event, pressedAt);
    return SensorProcessingResult(sosTrigger: trigger);
  }
}

class SensorProcessingResult {
  final MotionEvent? fallEvent;
  final MotionEvent? shakeEvent;
  final dynamic sosTrigger; // SosTrigger? — avoid circular import

  const SensorProcessingResult({
    this.fallEvent,
    this.shakeEvent,
    this.sosTrigger,
  });

  bool get hasFall => fallEvent?.type == MotionEventType.potentialFall;
  bool get hasShake => shakeEvent?.type == MotionEventType.shakeGesture;
  bool get hasSosTrigger => sosTrigger != null;
}
