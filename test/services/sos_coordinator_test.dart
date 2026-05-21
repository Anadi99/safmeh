import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/sos/sos.dart';
import 'package:safmeh/models/sos_event.dart';
import 'package:safmeh/models/trusted_contact.dart';
import 'package:safmeh/services/hardware_button_channel.dart';
import 'package:safmeh/services/mock_audio_evidence_service.dart';
import 'package:safmeh/services/mock_location_service.dart';
import 'package:safmeh/services/mock_notification_service.dart';
import 'package:safmeh/services/sos_coordinator.dart';

TrustedContact _contact() => TrustedContact(
      id: 'c1',
      userId: 'user-001',
      name: 'Mum',
      phoneNumber: '+1234567890',
      addedAt: DateTime.now(),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SosCoordinator', () {
    late SosCubit sosCubit;
    late MockAudioEvidenceService audioService;
    late MockNotificationService notificationService;
    late HardwareButtonChannel hardwareChannel;
    late SosCoordinator coordinator;

    setUp(() {
      // Stub the hardware button EventChannel so startListening() doesn't throw.
      const eventChannel = EventChannel('com.safmeh/hardware_button_events');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockStreamHandler(
        eventChannel,
        MockStreamHandler.inline(
          onListen: (args, sink) {},
          onCancel: (args) {},
        ),
      );

      final locationService = MockLocationService();
      sosCubit = SosCubit(
        repository: MockSosRepository(),
        locationService: locationService,
        userId: 'user-001',
      );
      audioService = MockAudioEvidenceService();
      notificationService = MockNotificationService();
      hardwareChannel = HardwareButtonChannel();
      coordinator = SosCoordinator(
        sosCubit: sosCubit,
        audioService: audioService,
        notificationService: notificationService,
        hardwareChannel: hardwareChannel,
        getContacts: () => [_contact()],
      );
    });

    tearDown(() async {
      coordinator.dispose();
      await sosCubit.close();
      audioService.dispose();
    });

    test('manual SOS activation starts audio recording', () async {
      coordinator.start();
      await sosCubit.activate(SosTrigger.manual);
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioService.isRecording, isTrue);
    });

    test('manual SOS activation sends emergency alert', () async {
      coordinator.start();
      await sosCubit.activate(SosTrigger.manual);
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notificationService.sentAlerts.length, greaterThan(0));
    });

    test('SOS deactivation stops audio recording', () async {
      coordinator.start();
      await sosCubit.activate(SosTrigger.manual);
      await Future.delayed(const Duration(milliseconds: 200));
      await sosCubit.deactivate();
      await Future.delayed(const Duration(milliseconds: 200));
      expect(audioService.isRecording, isFalse);
    });

    test('hardware gesture triggers SOS', () async {
      coordinator.start();
      await Future.microtask(() {});

      final now = DateTime.now().millisecondsSinceEpoch;
      hardwareChannel.simulateEvent({'type': 'power_button', 'timestamp': now});
      hardwareChannel.simulateEvent({'type': 'power_button', 'timestamp': now + 500});
      hardwareChannel.simulateEvent({'type': 'power_button', 'timestamp': now + 1000});

      await Future.delayed(const Duration(milliseconds: 300));
      expect(sosCubit.isActive, isTrue);
    });
  });
}
