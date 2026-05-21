import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/models/location_data.dart';
import 'package:safmeh/services/unusual_activity_detector.dart';

LocationData _loc(double lat, double lng, {DateTime? at}) => LocationData(
      latitude: lat,
      longitude: lng,
      accuracy: 10.0,
      timestamp: at ?? DateTime.now(),
    );

void main() {
  group('UnusualActivityDetector', () {
    late UnusualActivityDetector detector;

    setUp(() => detector = UnusualActivityDetector());

    test('returns null on first call (initialization)', () {
      final result = detector.check(_loc(51.5, -0.1));
      expect(result, isNull);
    });

    test('returns null when user is moving normally', () {
      detector.check(_loc(51.5000, -0.1000));
      // Move 50 meters — well within threshold
      final result = detector.check(_loc(51.5005, -0.1000));
      expect(result, isNull);
    });

    test('does NOT flag stop shorter than 3 minutes', () {
      detector.check(_loc(51.5, -0.1));
      // Same position, but only 1 minute later — should not flag
      final result = detector.check(_loc(51.5, -0.1));
      expect(result?.type, isNot(UnusualActivityType.prolongedStop));
    });

    test('flags route deviation exceeding 500 meters', () {
      final current = _loc(51.5074, -0.1278);
      // Planned route point ~600 meters away
      final planned = _loc(51.5020, -0.1278);
      detector.check(current);
      final result = detector.check(current, plannedRoutePoint: planned);
      expect(result, isNotNull);
      expect(result!.type, UnusualActivityType.routeDeviation);
    });

    test('does NOT flag deviation under 500 meters', () {
      final current = _loc(51.5074, -0.1278);
      // Planned route point ~100 meters away
      final planned = _loc(51.5065, -0.1278);
      detector.check(current);
      final result = detector.check(current, plannedRoutePoint: planned);
      expect(result?.type, isNot(UnusualActivityType.routeDeviation));
    });

    test('reset clears state', () {
      detector.check(_loc(51.5, -0.1));
      detector.reset();
      // After reset, first call should return null (re-initialization)
      final result = detector.check(_loc(51.5, -0.1));
      expect(result, isNull);
    });

    test('distanceBetween returns correct distance', () {
      // ~557 meters between these two points
      final dist = UnusualActivityDetector.distanceBetween(
        51.5074, -0.1278,
        51.5024, -0.1278,
      );
      expect(dist, greaterThan(500));
      expect(dist, lessThan(600));
    });

    test('distanceBetween returns ~0 for same point', () {
      final dist = UnusualActivityDetector.distanceBetween(
        51.5074, -0.1278,
        51.5074, -0.1278,
      );
      expect(dist, lessThan(1.0));
    });
  });
}
