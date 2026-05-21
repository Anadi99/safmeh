import 'dart:async';
import 'motion_detector_service.dart';
import 'fall_detector.dart';
import 'shake_detector.dart';

/// Mock motion detector for development/testing.
/// Simulates normal movement; can be manually triggered for testing.
class MockMotionDetectorService implements MotionDetectorService {
  final _controller = StreamController<MotionEvent>.broadcast();
  bool _isMonitoring = false;
  final _fallDetector = FallDetector();
  final _shakeDetector = ShakeDetector();

  @override
  Stream<MotionEvent> get motionStream => _controller.stream;

  @override
  bool get isMonitoring => _isMonitoring;

  @override
  Future<void> startMonitoring() async {
    _isMonitoring = true;
  }

  @override
  Future<void> stopMonitoring() async {
    _isMonitoring = false;
    _fallDetector.reset();
    _shakeDetector.reset();
  }

  /// Simulate a fall event (for testing).
  void simulateFall() {
    if (!_isMonitoring) return;
    final now = DateTime.now();
    // Peak reading
    final peak = AccelerometerReading(x: 30.0, y: 0, z: 0, timestamp: now);
    _fallDetector.process(peak);
    // Rest reading 500ms later
    final rest = AccelerometerReading(
      x: 0.5, y: 0, z: 0,
      timestamp: now.add(const Duration(milliseconds: 500)),
    );
    final event = _fallDetector.process(rest);
    if (event != null) _controller.add(event);
  }

  /// Simulate a shake gesture (for testing).
  void simulateShake() {
    if (!_isMonitoring) return;
    final start = DateTime.now();
    // Feed 2.1 seconds of high-acceleration readings
    for (int i = 0; i <= 21; i++) {
      final reading = AccelerometerReading(
        x: 20.0, y: 0, z: 0,
        timestamp: start.add(Duration(milliseconds: i * 100)),
      );
      final event = _shakeDetector.process(reading);
      if (event != null) {
        _controller.add(event);
        break;
      }
    }
  }

  void dispose() {
    _controller.close();
  }
}
