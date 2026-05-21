import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/fake_call/fake_call.dart';
import 'package:safmeh/models/fake_call_config.dart';
import 'package:safmeh/models/app_config.dart';
import 'package:safmeh/models/pretend_mode_config.dart';
import 'package:safmeh/models/sos_gesture_config.dart';
import 'package:safmeh/services/config_parser.dart';

const _config = FakeCallConfig(
  callerName: 'Mum',
  ringtonePath: 'assets/ringtone.mp3',
);

AppConfig _appConfig() => AppConfig(
      version: '1.0.0',
      pretendMode: const PretendModeConfig(
        secretPin: '1234',
        decoyType: DecoyAppType.calculator,
      ),
      fakeCall: _config,
      sosGestures: const SosGestureConfig(),
    );

void main() {
  group('FakeCallCubit', () {
    late FakeCallCubit cubit;

    setUp(() => cubit = FakeCallCubit());
    tearDown(() => cubit.close());

    test('initial state is FakeCallIdle', () {
      expect(cubit.state, isA<FakeCallIdle>());
    });

    test('triggerInstant emits FakeCallRinging', () {
      cubit.triggerInstant(_config);
      expect(cubit.state, isA<FakeCallRinging>());
    });

    test('ringing state has correct config', () {
      cubit.triggerInstant(_config);
      final state = cubit.state as FakeCallRinging;
      expect(state.config.callerName, 'Mum');
    });

    test('answerCall emits FakeCallActive', () {
      cubit.triggerInstant(_config);
      cubit.answerCall();
      expect(cubit.state, isA<FakeCallActive>());
    });

    test('endCall emits FakeCallEnded', () {
      cubit.triggerInstant(_config);
      cubit.endCall();
      expect(cubit.state, isA<FakeCallEnded>());
    });

    test('scheduleCall triggers after delay', () async {
      final scheduledAt = DateTime.now().add(const Duration(milliseconds: 200));
      cubit.scheduleCall(_config, scheduledAt);
      expect(cubit.state, isA<FakeCallIdle>()); // not yet
      await Future.delayed(const Duration(milliseconds: 300));
      expect(cubit.state, isA<FakeCallRinging>());
    });

    test('scheduleCall with past time triggers immediately', () {
      final past = DateTime.now().subtract(const Duration(seconds: 1));
      cubit.scheduleCall(_config, past);
      expect(cubit.state, isA<FakeCallRinging>());
    });
  });

  group('ConfigParser', () {
    test('parse returns config for valid JSON', () {
      final json = ConfigParser.format(_appConfig());
      final result = ConfigParser.parse(json);
      expect(result.config, isNotNull);
      expect(result.error, isNull);
    });

    test('parse returns error for invalid JSON', () {
      final result = ConfigParser.parse('not valid json {{{');
      expect(result.config, isNull);
      expect(result.error, isNotNull);
    });

    test('parse returns error for empty string', () {
      final result = ConfigParser.parse('');
      expect(result.config, isNull);
      expect(result.error, isNotNull);
    });

    test('round-trip: format then parse produces equivalent config', () {
      final original = _appConfig();
      final json = ConfigParser.format(original);
      final result = ConfigParser.parse(json);
      expect(result.config, isNotNull);
      expect(result.config!.version, original.version);
      expect(result.config!.fakeCall.callerName, original.fakeCall.callerName);
      expect(result.config!.pretendMode.secretPin, original.pretendMode.secretPin);
    });

    test('format produces valid JSON string', () {
      final json = ConfigParser.format(_appConfig());
      expect(() => jsonDecode(json), returnsNormally);
    });
  });
}
