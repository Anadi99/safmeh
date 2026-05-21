import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/services/fall_detector.dart';
import 'package:safmeh/services/motion_detector_service.dart';
import 'package:safmeh/services/shake_detector.dart';

AccelerometerReading _reading(double x, double y, double z, {DateTime? at}) =>
    AccelerometerReading(x: x, y: y, z: z, timestamp: at ?? DateTime.now());

void main() {
  group('FallDetector', () {
    late FallDetector detector;

    setUp(() => detector = FallDetector());

    test('returns null for normal acceleration', () {
      final result = detector.process(_reading(0, 0, 9.8));
      expect(result, isNull);
    });

    test('returns null for peak alone (no deceleration yet)', () {
      final result = detector.process(_reading(30, 0, 0));
      expect(result, isNull);
    });

    test('detects fall: peak >25 then <2 within 1 second', () {
      final now = DateTime.now();
      detector.process(_reading(30, 0, 0, at: now));
      final result = detector.process(
        _reading(0.5, 0, 0, at: now.add(const Duration(milliseconds: 500))),
      );
      expect(result, isNotNull);
      expect(result!.type, MotionEventType.potentialFall);
      expect(result.peakAcceleration, greaterThan(25));
    });

    test('does NOT detect fall if deceleration is outside 1-second window', () {
      final now = DateTime.now();
      detector.process(_reading(30, 0, 0, at: now));
      final result = detector.process(
        _reading(0.5, 0, 0, at: now.add(const Duration(milliseconds: 1500))),
      );
      expect(result, isNull);
    });

    test('does NOT detect fall if deceleration stays above rest threshold', () {
      final now = DateTime.now();
      detector.process(_reading(30, 0, 0, at: now));
      final result = detector.process(
        _reading(5, 0, 0, at: now.add(const Duration(milliseconds: 500))),
      );
      expect(result, isNull);
    });

    test('reset clears state', () {
      final now = DateTime.now();
      detector.process(_reading(30, 0, 0, at: now));
      detector.reset();
      final result = detector.process(
        _reading(0.5, 0, 0, at: now.add(const Duration(milliseconds: 500))),
      );
      expect(result, isNull);
    });
  });

  group('ShakeDetector', () {
    late ShakeDetector detector;

    setUp(() => detector = ShakeDetector());

    test('returns null for low acceleration', () {
      final result = detector.process(_reading(5, 0, 0));
      expect(result, isNull);
    });

    test('returns null for shake shorter than 2 seconds', () {
      final now = DateTime.now();
      MotionEvent? result;
      for (int i = 0; i < 10; i++) {
        result = detector.process(
          _reading(20, 0, 0, at: now.add(Duration(milliseconds: i * 100))),
        );
      }
      // Only 1 second of shaking — should not trigger
      expect(result, isNull);
    });

    test('detects shake after 2 seconds of sustained high acceleration', () {
      final now = DateTime.now();
      MotionEvent? result;
      for (int i = 0; i <= 21; i++) {
        result = detector.process(
          _reading(20, 0, 0, at: now.add(Duration(milliseconds: i * 100))),
        );
        if (result != null) break;
      }
      expect(result, isNotNull);
      expect(result!.type, MotionEventType.shakeGesture);
    });

    test('reset clears state', () {
      final now = DateTime.now();
      for (int i = 0; i <= 21; i++) {
        detector.process(
          _reading(20, 0, 0, at: now.add(Duration(milliseconds: i * 100))),
        );
      }
      detector.reset();
      // After reset, should not immediately trigger again
      final result = detector.process(_reading(20, 0, 0));
      expect(result, isNull);
    });
  });
}
