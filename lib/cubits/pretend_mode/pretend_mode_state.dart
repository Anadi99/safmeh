import 'package:equatable/equatable.dart';
import '../../models/pretend_mode_config.dart';

abstract class PretendModeState extends Equatable {
  const PretendModeState();
  @override
  List<Object?> get props => [];
}

class PretendModeOff extends PretendModeState {
  const PretendModeOff();
}

class PretendModeActive extends PretendModeState {
  final DecoyAppType decoyType;
  final String enteredPin;
  const PretendModeActive({required this.decoyType, this.enteredPin = ''});
  @override
  List<Object?> get props => [decoyType, enteredPin];
}

class PretendModeUnlocked extends PretendModeState {
  const PretendModeUnlocked();
}

class PretendModePinError extends PretendModeState {
  final DecoyAppType decoyType;
  const PretendModePinError(this.decoyType);
  @override
  List<Object?> get props => [decoyType];
}
