import 'dart:async';
import 'dart:math';
import '../models/location_data.dart';
import 'location_service.dart';

/// Mock location service that simulates movement for development/testing.
class MockLocationService implements LocationService {
  final _controller = StreamController<LocationData>.broadcast();
  Timer? _timer;
  bool _isTracking = false;

  // Simulated starting position (London)
  double _lat = 51.5074;
  double _lng = -0.1278;
  final _random = Random();

  @override
  Stream<LocationData> get locationStream => _controller.stream;

  @override
  bool get isTracking => _isTracking;

  @override
  Future<LocationData> getCurrentLocation({bool highAccuracy = false}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return LocationData(
      latitude: _lat,
      longitude: _lng,
      accuracy: highAccuracy ? 5.0 : 20.0,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<void> startBackgroundTracking(LocationSettings settings) async {
    if (_isTracking) return;
    _isTracking = true;
    _timer = Timer.periodic(
      Duration(milliseconds: settings.intervalMs),
      (_) => _emitLocation(),
    );
  }

  @override
  Future<void> stopBackgroundTracking() async {
    _timer?.cancel();
    _timer = null;
    _isTracking = false;
  }

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<bool> requestPermission() async => true;

  void _emitLocation() {
    // Simulate slight movement
    _lat += (_random.nextDouble() - 0.5) * 0.0001;
    _lng += (_random.nextDouble() - 0.5) * 0.0001;
    _controller.add(LocationData(
      latitude: _lat,
      longitude: _lng,
      accuracy: 15.0 + _random.nextDouble() * 10,
      speed: 1.0 + _random.nextDouble() * 2,
      timestamp: DateTime.now(),
    ));
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
