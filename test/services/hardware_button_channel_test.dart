import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/services/hardware_button_channel.dart';

void main() {
  group('HardwareButtonChannel', () {
    late HardwareButtonChannel channel;

    setUp(() => channel = HardwareButtonChannel());
    tearDown(() => channel.dispose());

    test('power button 3x within 2s triggers SOS', () async {
      final triggers = <SosTriggerEvent>[];
      final sub = channel.sosTriggerStream.listen(triggers.add);
      await Future.microtask(() {}); // let listener attach

      final now = DateTime.now().millisecondsSinceEpoch;
      channel.simulateEvent({'type': 'power_button', 'timestamp': now});
      channel.simulateEvent({'type': 'power_button', 'timestamp': now + 500});
      channel.simulateEvent({'type': 'power_button', 'timestamp': now + 1000});

      await Future.microtask(() {}); // let events propagate
      await sub.cancel();
      expect(triggers.length, 1);
    });

    test('volume up-up-down within 3s triggers SOS', () async {
      final triggers = <SosTriggerEvent>[];
      final sub = channel.sosTriggerStream.listen(triggers.add);
      await Future.microtask(() {}); // let listener attach

      final now = DateTime.now().millisecondsSinceEpoch;
      channel.simulateEvent({'type': 'volume_up', 'timestamp': now});
      channel.simulateEvent({'type': 'volume_up', 'timestamp': now + 500});
      channel.simulateEvent({'type': 'volume_down', 'timestamp': now + 1000});

      await Future.microtask(() {}); // let events propagate
      await sub.cancel();
      expect(triggers.length, 1);
    });

    test('ignores malformed events', () async {
      final triggers = <SosTriggerEvent>[];
      final sub = channel.sosTriggerStream.listen(triggers.add);

      channel.simulateEvent({'type': 'unknown'});
      channel.simulateEvent('not a map');
      channel.simulateEvent({});

      await sub.cancel();
      expect(triggers, isEmpty);
    });

    test('single power button press does not trigger SOS', () async {
      final triggers = <SosTriggerEvent>[];
      final sub = channel.sosTriggerStream.listen(triggers.add);

      channel.simulateEvent({
        'type': 'power_button',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      await sub.cancel();
      expect(triggers, isEmpty);
    });
  });
}
