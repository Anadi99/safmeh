import 'package:equatable/equatable.dart';

class FakeCallConfig extends Equatable {
  final String callerName;
  final String? callerPhotoUrl;
  final String ringtonePath;
  final String? voiceClipPath;

  const FakeCallConfig({
    required this.callerName,
    this.callerPhotoUrl,
    required this.ringtonePath,
    this.voiceClipPath,
  });

  Map<String, dynamic> toJson() => {
    'callerName': callerName,
    'callerPhotoUrl': callerPhotoUrl,
    'ringtonePath': ringtonePath,
    'voiceClipPath': voiceClipPath,
  };

  factory FakeCallConfig.fromJson(Map<String, dynamic> json) => FakeCallConfig(
    callerName: json['callerName'] as String,
    callerPhotoUrl: json['callerPhotoUrl'] as String?,
    ringtonePath: json['ringtonePath'] as String,
    voiceClipPath: json['voiceClipPath'] as String?,
  );

  FakeCallConfig copyWith({
    String? callerName,
    String? callerPhotoUrl,
    String? ringtonePath,
    String? voiceClipPath,
  }) => FakeCallConfig(
    callerName: callerName ?? this.callerName,
    callerPhotoUrl: callerPhotoUrl ?? this.callerPhotoUrl,
    ringtonePath: ringtonePath ?? this.ringtonePath,
    voiceClipPath: voiceClipPath ?? this.voiceClipPath,
  );

  @override
  List<Object?> get props => [callerName, callerPhotoUrl, ringtonePath, voiceClipPath];
}
