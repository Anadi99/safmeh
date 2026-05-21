import 'dart:math';

enum MotionEventType { potentialFall, shakeGesture, normalMovement }

class MotionEvent {
  final MotionEventType type;
  final double peakAcceleration;
  final DateTime timestamp;

  const MotionEvent({
    required this.type,
    required this.peakAcceleration,
    required this.timestamp,
  });
}

/// Abstract interface for motion detection.
abstract class MotionDetectorService {
  Stream<MotionEvent> get motionStream;
  Future<void> startMonitoring();
  Future<void> stopMonitoring();
  bool get isMonitoring;
}

/// Represents a single accelerometer reading.
class AccelerometerReading {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  const AccelerometerReading({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Magnitude of the acceleration vector in m/s².
  double get magnitude => sqrt(x * x + y * y + z * z);
}
