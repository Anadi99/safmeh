import 'package:equatable/equatable.dart';
import 'location_data.dart';

enum RouteShareStatus { active, ended }

class RouteShareSession extends Equatable {
  final String id;
  final String userId;
  final List<String> contactIds;
  final double destinationLat;
  final double destinationLng;
  final DateTime startTime;
  final DateTime? expiresAt;
  final RouteShareStatus status;
  final LocationData? lastLocation;
  final int? batteryPercent;
  final String? etaString;

  const RouteShareSession({
    required this.id,
    required this.userId,
    required this.contactIds,
    required this.destinationLat,
    required this.destinationLng,
    required this.startTime,
    this.expiresAt,
    required this.status,
    this.lastLocation,
    this.batteryPercent,
    this.etaString,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'contactIds': contactIds,
    'destinationLat': destinationLat,
    'destinationLng': destinationLng,
    'startTime': startTime.toIso8601String(),
    'expiresAt': expiresAt?.toIso8601String(),
    'status': status.name,
    'lastLocation': lastLocation?.toJson(),
    'batteryPercent': batteryPercent,
    'etaString': etaString,
  };

  factory RouteShareSession.fromJson(Map<String, dynamic> json) => RouteShareSession(
    id: json['id'] as String,
    userId: json['userId'] as String,
    contactIds: List<String>.from(json['contactIds'] as List? ?? []),
    destinationLat: (json['destinationLat'] as num).toDouble(),
    destinationLng: (json['destinationLng'] as num).toDouble(),
    startTime: DateTime.parse(json['startTime'] as String),
    expiresAt: json['expiresAt'] != null
        ? DateTime.parse(json['expiresAt'] as String)
        : null,
    status: RouteShareStatus.values.byName(json['status'] as String),
    lastLocation: json['lastLocation'] != null
        ? LocationData.fromJson(json['lastLocation'] as Map<String, dynamic>)
        : null,
    batteryPercent: json['batteryPercent'] as int?,
    etaString: json['etaString'] as String?,
  );

  RouteShareSession copyWith({
    RouteShareStatus? status,
    LocationData? lastLocation,
    int? batteryPercent,
    String? etaString,
  }) => RouteShareSession(
    id: id,
    userId: userId,
    contactIds: contactIds,
    destinationLat: destinationLat,
    destinationLng: destinationLng,
    startTime: startTime,
    expiresAt: expiresAt,
    status: status ?? this.status,
    lastLocation: lastLocation ?? this.lastLocation,
    batteryPercent: batteryPercent ?? this.batteryPercent,
    etaString: etaString ?? this.etaString,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    contactIds,
    destinationLat,
    destinationLng,
    startTime,
    expiresAt,
    status,
    lastLocation,
    batteryPercent,
    etaString,
  ];
}
