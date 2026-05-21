import '../models/location_data.dart';

enum LocationAccuracyMode { high, balanced, low }

class LocationSettings {
  final LocationAccuracyMode accuracy;
  final int intervalMs;
  final double distanceFilterMeters;

  const LocationSettings({
    this.accuracy = LocationAccuracyMode.balanced,
    this.intervalMs = 10000,
    this.distanceFilterMeters = 10,
  });
}

/// Abstract interface — swap in real geolocator impl when Firebase is configured.
abstract class LocationService {
  Stream<LocationData> get locationStream;
  Future<LocationData> getCurrentLocation({bool highAccuracy = false});
  Future<void> startBackgroundTracking(LocationSettings settings);
  Future<void> stopBackgroundTracking();
  bool get isTracking;
  Future<bool> isLocationServiceEnabled();
  Future<bool> requestPermission();
}
