import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pretend_mode_config.dart';
import '../../services/pin_validator.dart';
import 'pretend_mode_state.dart';

class PretendModeCubit extends Cubit<PretendModeState> {
  PretendModeConfig? _config;

  PretendModeCubit() : super(const PretendModeOff());

  /// Enable pretend mode with the given config.
  void enable(PretendModeConfig config) {
    _config = config;
    emit(PretendModeActive(decoyType: config.decoyType));
  }

  /// Disable pretend mode and return to normal.
  void disable() {
    _config = null;
    emit(const PretendModeOff());
  }

  /// Called when user enters a digit in the decoy PIN field.
  void onPinInput(String pin) {
    final config = _config;
    if (config == null) return;

    if (PinValidator.validate(pin, config.secretPin)) {
      emit(const PretendModeUnlocked());
    } else if (pin.length >= config.secretPin.length) {
      // Wrong PIN of correct length — show error briefly, stay in decoy
      emit(PretendModePinError(config.decoyType));
      // Reset back to active after brief delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (state is PretendModePinError) {
          emit(PretendModeActive(decoyType: config.decoyType));
        }
      });
    } else {
      // Still typing — update entered pin display
      emit(PretendModeActive(decoyType: config.decoyType, enteredPin: pin));
    }
  }

  /// User exits the Safety Dashboard — return to decoy.
  void lockToDashboard() {
    final config = _config;
    if (config != null) {
      emit(PretendModeActive(decoyType: config.decoyType));
    } else {
      emit(const PretendModeOff());
    }
  }

  bool get isActive => state is PretendModeActive || state is PretendModePinError;
  bool get isUnlocked => state is PretendModeUnlocked;
}
