import 'package:equatable/equatable.dart';
import 'location_data.dart';

enum SosTrigger { powerButton, shake, volumePattern, voiceKeyword, manual, autoDetect }

enum SosStatus { active, resolved }

class SosEvent extends Equatable {
  final String id;
  final String userId;
  final SosTrigger trigger;
  final DateTime activatedAt;
  final DateTime? deactivatedAt;
  final LocationData locationAtActivation;
  final List<String> audioSegmentUrls;
  final SosStatus status;

  const SosEvent({
    required this.id,
    required this.userId,
    required this.trigger,
    required this.activatedAt,
    this.deactivatedAt,
    required this.locationAtActivation,
    this.audioSegmentUrls = const [],
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'trigger': trigger.name,
    'activatedAt': activatedAt.toIso8601String(),
    'deactivatedAt': deactivatedAt?.toIso8601String(),
    'locationAtActivation': locationAtActivation.toJson(),
    'audioSegmentUrls': audioSegmentUrls,
    'status': status.name,
  };

  factory SosEvent.fromJson(Map<String, dynamic> json) => SosEvent(
    id: json['id'] as String,
    userId: json['userId'] as String,
    trigger: SosTrigger.values.byName(json['trigger'] as String),
    activatedAt: DateTime.parse(json['activatedAt'] as String),
    deactivatedAt: json['deactivatedAt'] != null
        ? DateTime.parse(json['deactivatedAt'] as String)
        : null,
    locationAtActivation: LocationData.fromJson(
      json['locationAtActivation'] as Map<String, dynamic>,
    ),
    audioSegmentUrls: List<String>.from(json['audioSegmentUrls'] as List? ?? []),
    status: SosStatus.values.byName(json['status'] as String),
  );

  SosEvent copyWith({
    SosStatus? status,
    DateTime? deactivatedAt,
    List<String>? audioSegmentUrls,
  }) => SosEvent(
    id: id,
    userId: userId,
    trigger: trigger,
    activatedAt: activatedAt,
    deactivatedAt: deactivatedAt ?? this.deactivatedAt,
    locationAtActivation: locationAtActivation,
    audioSegmentUrls: audioSegmentUrls ?? this.audioSegmentUrls,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    trigger,
    activatedAt,
    deactivatedAt,
    locationAtActivation,
    audioSegmentUrls,
    status,
  ];
}
