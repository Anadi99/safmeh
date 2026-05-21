import 'dart:async';
import 'battery_cubit.dart';

class MockBatteryRepository implements BatteryRepository {
  int _percent;
  final _controller = StreamController<int>.broadcast();

  MockBatteryRepository({int initialPercent = 100}) : _percent = initialPercent;

  @override
  Future<int> getBatteryPercent() async => _percent;

  @override
  Stream<int> get batteryStream => _controller.stream;

  /// Simulate battery level change (for testing).
  void setPercent(int percent) {
    _percent = percent;
    _controller.add(percent);
  }

  void dispose() => _controller.close();
}
