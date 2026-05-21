import 'package:flutter_test/flutter_test.dart';
import 'package:safmeh/models/location_data.dart';
import 'package:safmeh/services/location_serializer.dart';

void main() {
  final serializer = LocationSerializer();

  group('LocationSerializer', () {
    test('serialized output contains all required fields', () {
      final loc = LocationData(
        latitude: 51.5074,
        longitude: -0.1278,
        accuracy: 10.0,
        timestamp: DateTime(2026, 1, 1, 12, 0, 0),
      );
      final json = serializer.serialize(loc);
      expect(json.containsKey('latitude'), isTrue);
      expect(json.containsKey('longitude'), isTrue);
      expect(json.containsKey('accuracy'), isTrue);
      expect(json.containsKey('timestamp'), isTrue);
    });

    test('round-trip: serialize then deserialize produces equivalent object', () {
      final original = LocationData(
        latitude: 48.8566,
        longitude: 2.3522,
        accuracy: 8.5,
        altitude: 35.0,
        speed: 1.2,
        timestamp: DateTime(2026, 6, 15, 9, 30, 0),
      );
      final json = serializer.serialize(original);
      final restored = serializer.deserialize(json);
      expect(restored, isNotNull);
      expect(restored!.latitude, original.latitude);
      expect(restored.longitude, original.longitude);
      expect(restored.accuracy, original.accuracy);
      expect(restored.altitude, original.altitude);
      expect(restored.speed, original.speed);
      expect(restored.timestamp, original.timestamp);
    });

    test('deserialize returns null for missing required fields', () {
      expect(serializer.deserialize({}), isNull);
      expect(serializer.deserialize({'latitude': 1.0}), isNull);
      expect(serializer.deserialize({'latitude': 1.0, 'longitude': 2.0}), isNull);
    });

    test('deserialize returns null for malformed timestamp', () {
      final json = {
        'latitude': 51.5,
        'longitude': -0.1,
        'accuracy': 10.0,
        'timestamp': 'not-a-date',
      };
      expect(serializer.deserialize(json), isNull);
    });

    test('hasRequiredFields returns true for complete json', () {
      final json = serializer.serialize(LocationData(
        latitude: 1.0,
        longitude: 2.0,
        accuracy: 5.0,
        timestamp: DateTime.now(),
      ));
      expect(serializer.hasRequiredFields(json), isTrue);
    });

    test('hasRequiredFields returns false for incomplete json', () {
      expect(serializer.hasRequiredFields({'latitude': 1.0}), isFalse);
      expect(serializer.hasRequiredFields({}), isFalse);
    });

    test('optional fields altitude and speed are omitted when null', () {
      final loc = LocationData(
        latitude: 1.0,
        longitude: 2.0,
        accuracy: 5.0,
        timestamp: DateTime.now(),
      );
      final json = serializer.serialize(loc);
      expect(json.containsKey('altitude'), isFalse);
      expect(json.containsKey('speed'), isFalse);
    });

    test('optional fields are null when absent from json', () {
      final json = {
        'latitude': 51.5,
        'longitude': -0.1,
        'accuracy': 10.0,
        'timestamp': '2026-01-01T12:00:00.000',
      };
      final loc = serializer.deserialize(json);
      expect(loc, isNotNull);
      expect(loc!.altitude, isNull);
      expect(loc.speed, isNull);
    });
  });
}
