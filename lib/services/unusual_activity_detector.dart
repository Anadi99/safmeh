import 'dart:math';
import '../models/location_data.dart';

enum UnusualActivityType { prolongedStop, routeDeviation }

class UnusualActivity {
  final UnusualActivityType type;
  final LocationData location;
  final String description;

  const UnusualActivity({
    required this.type,
    required this.location,
    required this.description,
  });
}

class UnusualActivityDetector {
  static const int stopThresholdSeconds = 180; // 3 minutes
  static const double deviationThresholdMeters = 500.0;

  LocationData? _lastMovementLocation;
  DateTime? _lastMovementTime;

  /// Call this on every new location update.
  /// Returns an [UnusualActivity] if something suspicious is detected, or null.
  UnusualActivity? check(LocationData current, {LocationData? plannedRoutePoint}) {
    final now = DateTime.now();

    // Initialize on first call
    if (_lastMovementLocation == null) {
      _lastMovementLocation = current;
      _lastMovementTime = now;
      return null;
    }

    final distanceMoved = _haversineDistance(
      _lastMovementLocation!.latitude,
      _lastMovementLocation!.longitude,
      current.latitude,
      current.longitude,
    );

    // If moved more than 10 meters, reset the stop timer
    if (distanceMoved > 10.0) {
      _lastMovementLocation = current;
      _lastMovementTime = now;
    }

    // Check for prolonged stop
    final stoppedDuration = now.difference(_lastMovementTime!);
    if (stoppedDuration.inSeconds > stopThresholdSeconds) {
      return UnusualActivity(
        type: UnusualActivityType.prolongedStop,
        location: current,
        description:
            'No movement detected for ${stoppedDuration.inMinutes} minute(s).',
      );
    }

    // Check for route deviation
    if (plannedRoutePoint != null) {
      final deviation = _haversineDistance(
        current.latitude,
        current.longitude,
        plannedRoutePoint.latitude,
        plannedRoutePoint.longitude,
      );
      if (deviation > deviationThresholdMeters) {
        return UnusualActivity(
          type: UnusualActivityType.routeDeviation,
          location: current,
          description:
              'Route deviation of ${deviation.toStringAsFixed(0)} meters detected.',
        );
      }
    }

    return null;
  }

  /// Reset the detector state (call when starting a new session).
  void reset() {
    _lastMovementLocation = null;
    _lastMovementTime = null;
  }

  /// Haversine formula — returns distance in meters between two lat/lng points.
  static double _haversineDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const earthRadiusMeters = 6371000.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180;

  /// Public static helper for use in tests and other services.
  static double distanceBetween(
    double lat1, double lon1,
    double lat2, double lon2,
  ) => _haversineDistance(lat1, lon1, lat2, lon2);
}
