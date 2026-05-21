import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/services/background_sensor_processor.dart';
import 'package:safmeh/services/motion_detector_service.dart';
import 'package:safmeh/services/sos_gesture_detector.dart';

AccelerometerReading _reading(double x, double y, double z, {DateTime? at}) =>
    AccelerometerReading(x: x, y: y, z: z, timestamp: at ?? DateTime.now());

void main() {
  group('BackgroundSensorProcessor', () {
    late BackgroundSensorProcessor processor;

    setUp(() => processor = BackgroundSensorProcessor());

    test('isRunning is false initially', () {
      expect(processor.isRunning, isFalse);
    });

    test('start sets isRunning to true', () {
      processor.start();
      expect(processor.isRunning, isTrue);
    });

    test('stop sets isRunning to false', () {
      processor.start();
      processor.stop();
      expect(processor.isRunning, isFalse);
    });

    test('processAccelerometer returns empty result when not running', () {
      final result = processor.processAccelerometer(_reading(30, 0, 0));
      expect(result.hasFall, isFalse);
      expect(result.hasShake, isFalse);
    });

    test('detects fall when running', () {
      processor.start();
      final now = DateTime.now();
      processor.processAccelerometer(_reading(30, 0, 0, at: now));
      final result = processor.processAccelerometer(
        _reading(0.5, 0, 0, at: now.add(const Duration(milliseconds: 500))),
      );
      expect(result.hasFall, isTrue);
    });

    test('detects shake when running', () {
      processor.start();
      final now = DateTime.now();
      SensorProcessingResult? result;
      for (int i = 0; i <= 21; i++) {
        result = processor.processAccelerometer(
          _reading(20, 0, 0, at: now.add(Duration(milliseconds: i * 100))),
        );
        if (result.hasShake) break;
      }
      expect(result?.hasShake, isTrue);
    });

    test('detects power button SOS when running', () {
      processor.start();
      final now = DateTime.now();
      processor.processPowerButtonPress(now);
      processor.processPowerButtonPress(now.add(const Duration(milliseconds: 500)));
      final result = processor.processPowerButtonPress(
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result.hasSosTrigger, isTrue);
    });

    test('detects volume pattern SOS when running', () {
      processor.start();
      final now = DateTime.now();
      processor.processVolumeButtonPress(VolumeButtonEvent.up, now);
      processor.processVolumeButtonPress(
        VolumeButtonEvent.up,
        now.add(const Duration(milliseconds: 500)),
      );
      final result = processor.processVolumeButtonPress(
        VolumeButtonEvent.down,
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result.hasSosTrigger, isTrue);
    });
  });
}
