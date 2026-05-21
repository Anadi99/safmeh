import 'package:equatable/equatable.dart';
import 'location_data.dart';

enum SafeWalkStatus { active, paused, ended, emergency }

class UnusualActivityEvent extends Equatable {
  final String type; // 'stop', 'deviation', 'fall', 'shake'
  final DateTime detectedAt;
  final LocationData? location;

  const UnusualActivityEvent({
    required this.type,
    required this.detectedAt,
    this.location,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'detectedAt': detectedAt.toIso8601String(),
    'location': location?.toJson(),
  };

  factory UnusualActivityEvent.fromJson(Map<String, dynamic> json) =>
      UnusualActivityEvent(
        type: json['type'] as String,
        detectedAt: DateTime.parse(json['detectedAt'] as String),
        location: json['location'] != null
            ? LocationData.fromJson(json['location'] as Map<String, dynamic>)
            : null,
      );

  @override
  List<Object?> get props => [type, detectedAt, location];
}

class SafeWalkSession extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final SafeWalkStatus status;
  final double? destinationLat;
  final double? destinationLng;
  final List<LocationData> locationHistory;
  final List<UnusualActivityEvent> activityEvents;

  const SafeWalkSession({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.status,
    this.destinationLat,
    this.destinationLng,
    this.locationHistory = const [],
    this.activityEvents = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'status': status.name,
    'destinationLat': destinationLat,
    'destinationLng': destinationLng,
    'locationHistory': locationHistory.map((l) => l.toJson()).toList(),
    'activityEvents': activityEvents.map((e) => e.toJson()).toList(),
  };

  factory SafeWalkSession.fromJson(Map<String, dynamic> json) => SafeWalkSession(
    id: json['id'] as String,
    userId: json['userId'] as String,
    startTime: DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] != null
        ? DateTime.parse(json['endTime'] as String)
        : null,
    status: SafeWalkStatus.values.byName(json['status'] as String),
    destinationLat: json['destinationLat'] != null
        ? (json['destinationLat'] as num).toDouble()
        : null,
    destinationLng: json['destinationLng'] != null
        ? (json['destinationLng'] as num).toDouble()
        : null,
    locationHistory: (json['locationHistory'] as List<dynamic>? ?? [])
        .map((e) => LocationData.fromJson(e as Map<String, dynamic>))
        .toList(),
    activityEvents: (json['activityEvents'] as List<dynamic>? ?? [])
        .map((e) => UnusualActivityEvent.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  SafeWalkSession copyWith({
    SafeWalkStatus? status,
    DateTime? endTime,
    List<LocationData>? locationHistory,
    List<UnusualActivityEvent>? activityEvents,
  }) => SafeWalkSession(
    id: id,
    userId: userId,
    startTime: startTime,
    endTime: endTime ?? this.endTime,
    status: status ?? this.status,
    destinationLat: destinationLat,
    destinationLng: destinationLng,
    locationHistory: locationHistory ?? this.locationHistory,
    activityEvents: activityEvents ?? this.activityEvents,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    startTime,
    endTime,
    status,
    destinationLat,
    destinationLng,
    locationHistory,
    activityEvents,
  ];
}
