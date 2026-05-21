import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/cubits/pretend_mode/pretend_mode.dart';
import 'package:safmeh/models/pretend_mode_config.dart';
import 'package:safmeh/services/pin_validator.dart';

void main() {
  group('PinValidator', () {
    test('returns true for matching PIN', () {
      expect(PinValidator.validate('1234', '1234'), isTrue);
    });

    test('returns false for non-matching PIN', () {
      expect(PinValidator.validate('0000', '1234'), isFalse);
    });

    test('returns false for partial PIN', () {
      expect(PinValidator.validate('12', '1234'), isFalse);
    });

    test('is case-sensitive', () {
      expect(PinValidator.validate('abcd', 'ABCD'), isFalse);
    });
  });

  group('PretendModeCubit', () {
    late PretendModeCubit cubit;
    const config = PretendModeConfig(
      secretPin: '1234',
      decoyType: DecoyAppType.calculator,
    );

    setUp(() => cubit = PretendModeCubit());
    tearDown(() => cubit.close());

    test('initial state is PretendModeOff', () {
      expect(cubit.state, isA<PretendModeOff>());
    });

    test('enable emits PretendModeActive', () {
      cubit.enable(config);
      expect(cubit.state, isA<PretendModeActive>());
    });

    test('active state has correct decoy type', () {
      cubit.enable(config);
      final state = cubit.state as PretendModeActive;
      expect(state.decoyType, DecoyAppType.calculator);
    });

    test('correct PIN emits PretendModeUnlocked', () {
      cubit.enable(config);
      cubit.onPinInput('1234');
      expect(cubit.state, isA<PretendModeUnlocked>());
    });

    test('wrong PIN of correct length emits PretendModePinError', () {
      cubit.enable(config);
      cubit.onPinInput('0000');
      expect(cubit.state, isA<PretendModePinError>());
    });

    test('partial PIN updates enteredPin in PretendModeActive', () {
      cubit.enable(config);
      cubit.onPinInput('12');
      final state = cubit.state as PretendModeActive;
      expect(state.enteredPin, '12');
    });

    test('disable emits PretendModeOff', () {
      cubit.enable(config);
      cubit.disable();
      expect(cubit.state, isA<PretendModeOff>());
    });

    test('isActive is true when PretendModeActive', () {
      cubit.enable(config);
      expect(cubit.isActive, isTrue);
    });

    test('isUnlocked is true when PretendModeUnlocked', () {
      cubit.enable(config);
      cubit.onPinInput('1234');
      expect(cubit.isUnlocked, isTrue);
    });

    test('lockToDashboard returns to PretendModeActive', () {
      cubit.enable(config);
      cubit.onPinInput('1234'); // unlock
      cubit.lockToDashboard();  // lock back
      expect(cubit.state, isA<PretendModeActive>());
    });
  });
}
