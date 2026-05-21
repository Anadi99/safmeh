import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/battery/battery.dart';
import 'package:safmeh/services/battery_threshold_manager.dart';

void main() {
  group('BatteryThresholdManager', () {
    final manager = BatteryThresholdManager();

    test('classifies 100% as normal', () {
      expect(manager.classify(100), BatteryLevel.normal);
    });

    test('classifies 20% as low', () {
      expect(manager.classify(20), BatteryLevel.low);
    });

    test('classifies 19% as low', () {
      expect(manager.classify(19), BatteryLevel.low);
    });

    test('classifies 10% as critical', () {
      expect(manager.classify(10), BatteryLevel.critical);
    });

    test('classifies 5% as veryLow', () {
      expect(manager.classify(5), BatteryLevel.veryLow);
    });

    test('locationIntervalMs is 10000 above 20%', () {
      expect(manager.locationIntervalMs(50), 10000);
    });

    test('locationIntervalMs is 30000 below 20%', () {
      expect(manager.locationIntervalMs(15), 30000);
    });

    test('shouldNotifyContacts is true at 10%', () {
      expect(manager.shouldNotifyContacts(10), isTrue);
    });

    test('shouldNotifyContacts is false at 11%', () {
      expect(manager.shouldNotifyContacts(11), isFalse);
    });

    test('shouldSendFinalLocation is true at 5%', () {
      expect(manager.shouldSendFinalLocation(5), isTrue);
    });

    test('shouldSendFinalLocation is false at 6%', () {
      expect(manager.shouldSendFinalLocation(6), isFalse);
    });
  });

  group('BatteryCubit', () {
    late BatteryCubit cubit;
    late MockBatteryRepository repository;

    setUp(() {
      repository = MockBatteryRepository(initialPercent: 100);
      cubit = BatteryCubit(repository: repository);
    });

    tearDown(() {
      cubit.close();
      repository.dispose();
    });

    test('initial state is BatteryInitial', () {
      expect(cubit.state, isA<BatteryInitial>());
    });

    test('checkBattery emits BatteryUpdated', () async {
      await cubit.checkBattery();
      expect(cubit.state, isA<BatteryUpdated>());
    });

    test('emits correct percent', () async {
      await cubit.checkBattery();
      expect((cubit.state as BatteryUpdated).percent, 100);
    });

    test('emits low level at 15%', () async {
      repository.setPercent(15);
      await cubit.checkBattery();
      expect((cubit.state as BatteryUpdated).level, BatteryLevel.low);
    });

    test('emits critical level at 8%', () async {
      repository.setPercent(8);
      await cubit.checkBattery();
      expect((cubit.state as BatteryUpdated).level, BatteryLevel.critical);
    });

    test('shouldNotifyContacts is true at 8%', () async {
      repository.setPercent(8);
      await cubit.checkBattery();
      expect(cubit.shouldNotifyContacts, isTrue);
    });

    test('currentLocationIntervalMs is 30000 at 15%', () async {
      repository.setPercent(15);
      await cubit.checkBattery();
      expect(cubit.currentLocationIntervalMs, 30000);
    });
  });
}
