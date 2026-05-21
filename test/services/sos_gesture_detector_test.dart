import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/models/sos_event.dart';
import 'package:safmeh/services/sos_gesture_detector.dart';

void main() {
  group('SosGestureDetector — Power Button', () {
    late SosGestureDetector detector;

    setUp(() => detector = SosGestureDetector());

    test('returns null for 1 press', () {
      final now = DateTime.now();
      expect(detector.onPowerButtonPress(now), isNull);
    });

    test('returns null for 2 presses within window', () {
      final now = DateTime.now();
      detector.onPowerButtonPress(now);
      expect(
        detector.onPowerButtonPress(now.add(const Duration(milliseconds: 500))),
        isNull,
      );
    });

    test('triggers SOS on 3 presses within 2 seconds', () {
      final now = DateTime.now();
      detector.onPowerButtonPress(now);
      detector.onPowerButtonPress(now.add(const Duration(milliseconds: 500)));
      final result = detector.onPowerButtonPress(
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result, SosTrigger.powerButton);
    });

    test('does NOT trigger SOS if 3 presses span more than 2 seconds', () {
      final now = DateTime.now();
      detector.onPowerButtonPress(now);
      detector.onPowerButtonPress(now.add(const Duration(milliseconds: 1000)));
      final result = detector.onPowerButtonPress(
        now.add(const Duration(milliseconds: 2500)),
      );
      // First press is now outside the window — only 2 presses in window
      expect(result, isNull);
    });

    test('resets after triggering', () {
      final now = DateTime.now();
      detector.onPowerButtonPress(now);
      detector.onPowerButtonPress(now.add(const Duration(milliseconds: 500)));
      detector.onPowerButtonPress(now.add(const Duration(milliseconds: 1000)));
      // Triggered — now press again, should not immediately trigger
      final result = detector.onPowerButtonPress(
        now.add(const Duration(milliseconds: 1100)),
      );
      expect(result, isNull);
    });
  });

  group('SosGestureDetector — Volume Pattern', () {
    late SosGestureDetector detector;

    setUp(() => detector = SosGestureDetector());

    test('returns null for single up press', () {
      final now = DateTime.now();
      expect(
        detector.onVolumeButtonPress(VolumeButtonEvent.up, now),
        isNull,
      );
    });

    test('returns null for up-up pattern (incomplete)', () {
      final now = DateTime.now();
      detector.onVolumeButtonPress(VolumeButtonEvent.up, now);
      expect(
        detector.onVolumeButtonPress(
          VolumeButtonEvent.up,
          now.add(const Duration(milliseconds: 500)),
        ),
        isNull,
      );
    });

    test('triggers SOS on up-up-down within 3 seconds', () {
      final now = DateTime.now();
      detector.onVolumeButtonPress(VolumeButtonEvent.up, now);
      detector.onVolumeButtonPress(
        VolumeButtonEvent.up,
        now.add(const Duration(milliseconds: 500)),
      );
      final result = detector.onVolumeButtonPress(
        VolumeButtonEvent.down,
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result, SosTrigger.volumePattern);
    });

    test('does NOT trigger SOS for up-down-up pattern', () {
      final now = DateTime.now();
      detector.onVolumeButtonPress(VolumeButtonEvent.up, now);
      detector.onVolumeButtonPress(
        VolumeButtonEvent.down,
        now.add(const Duration(milliseconds: 500)),
      );
      final result = detector.onVolumeButtonPress(
        VolumeButtonEvent.up,
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result, isNull);
    });

    test('does NOT trigger SOS if pattern spans more than 3 seconds', () {
      final now = DateTime.now();
      detector.onVolumeButtonPress(VolumeButtonEvent.up, now);
      detector.onVolumeButtonPress(
        VolumeButtonEvent.up,
        now.add(const Duration(milliseconds: 1500)),
      );
      final result = detector.onVolumeButtonPress(
        VolumeButtonEvent.down,
        now.add(const Duration(milliseconds: 3500)),
      );
      // First up is now outside the 3s window
      expect(result, isNull);
    });

    test('reset clears state', () {
      final now = DateTime.now();
      detector.onVolumeButtonPress(VolumeButtonEvent.up, now);
      detector.onVolumeButtonPress(
        VolumeButtonEvent.up,
        now.add(const Duration(milliseconds: 500)),
      );
      detector.reset();
      final result = detector.onVolumeButtonPress(
        VolumeButtonEvent.down,
        now.add(const Duration(milliseconds: 1000)),
      );
      expect(result, isNull);
    });
  });
}
