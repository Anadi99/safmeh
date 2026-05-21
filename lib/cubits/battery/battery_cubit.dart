import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/battery_threshold_manager.dart';
import 'battery_state.dart';

abstract class BatteryRepository {
  Future<int> getBatteryPercent();
  Stream<int> get batteryStream;
}

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository _repository;
  final BatteryThresholdManager _thresholdManager;

  BatteryCubit({
    required BatteryRepository repository,
    BatteryThresholdManager? thresholdManager,
  })  : _repository = repository,
        _thresholdManager = thresholdManager ?? BatteryThresholdManager(),
        super(const BatteryInitial());

  Future<void> checkBattery() async {
    final percent = await _repository.getBatteryPercent();
    _update(percent);
  }

  void startMonitoring() {
    _repository.batteryStream.listen(_update);
  }

  void _update(int percent) {
    final level = _thresholdManager.classify(percent);
    final interval = _thresholdManager.locationIntervalMs(percent);
    emit(BatteryUpdated(
      percent: percent,
      level: level,
      locationIntervalMs: interval,
    ));
  }

  bool get shouldNotifyContacts {
    final s = state;
    if (s is BatteryUpdated) {
      return _thresholdManager.shouldNotifyContacts(s.percent);
    }
    return false;
  }

  bool get shouldSendFinalLocation {
    final s = state;
    if (s is BatteryUpdated) {
      return _thresholdManager.shouldSendFinalLocation(s.percent);
    }
    return false;
  }

  int get currentLocationIntervalMs {
    final s = state;
    if (s is BatteryUpdated) return s.locationIntervalMs;
    return 10000;
  }
}
