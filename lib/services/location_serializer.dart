import '../models/location_data.dart';

class LocationSerializationError {
  final String message;
  const LocationSerializationError(this.message);
}

class LocationSerializer {
  /// Serializes a LocationData to a JSON map.
  /// Always includes: latitude, longitude, accuracy, timestamp.
  Map<String, dynamic> serialize(LocationData location) {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'accuracy': location.accuracy,
      'timestamp': location.timestamp.toIso8601String(),
      if (location.altitude != null) 'altitude': location.altitude,
      if (location.speed != null) 'speed': location.speed,
    };
  }

  /// Deserializes a JSON map to LocationData.
  /// Returns null if required fields are missing or malformed.
  LocationData? deserialize(Map<String, dynamic> json) {
    try {
      final lat = json['latitude'];
      final lng = json['longitude'];
      final acc = json['accuracy'];
      final ts = json['timestamp'];
      if (lat == null || lng == null || acc == null || ts == null) return null;
      return LocationData(
        latitude: (lat as num).toDouble(),
        longitude: (lng as num).toDouble(),
        accuracy: (acc as num).toDouble(),
        timestamp: DateTime.parse(ts as String),
        altitude: json['altitude'] != null ? (json['altitude'] as num).toDouble() : null,
        speed: json['speed'] != null ? (json['speed'] as num).toDouble() : null,
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns true if the serialized map contains all required fields.
  bool hasRequiredFields(Map<String, dynamic> json) {
    return json.containsKey('latitude') &&
        json.containsKey('longitude') &&
        json.containsKey('accuracy') &&
        json.containsKey('timestamp');
  }
}
