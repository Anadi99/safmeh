import 'package:equatable/equatable.dart';
import '../../services/battery_threshold_manager.dart';

abstract class BatteryState extends Equatable {
  const BatteryState();
  @override
  List<Object?> get props => [];
}

class BatteryInitial extends BatteryState {
  const BatteryInitial();
}

class BatteryUpdated extends BatteryState {
  final int percent;
  final BatteryLevel level;
  final int locationIntervalMs;

  const BatteryUpdated({
    required this.percent,
    required this.level,
    required this.locationIntervalMs,
  });

  @override
  List<Object?> get props => [percent, level, locationIntervalMs];
}
