import 'package:equatable/equatable.dart';
import 'pretend_mode_config.dart';

class VoiceKeywordConfig extends Equatable {
  final String keyword;
  final bool enabled;

  const VoiceKeywordConfig({required this.keyword, required this.enabled});

  Map<String, dynamic> toJson() => {'keyword': keyword, 'enabled': enabled};

  factory VoiceKeywordConfig.fromJson(Map<String, dynamic> json) =>
      VoiceKeywordConfig(
        keyword: json['keyword'] as String,
        enabled: json['enabled'] as bool,
      );

  @override
  List<Object?> get props => [keyword, enabled];
}

class UserProfile extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool biometricEnabled;
  final PretendModeConfig? pretendMode;
  final VoiceKeywordConfig? voiceKeyword;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.biometricEnabled = false,
    this.pretendMode,
    this.voiceKeyword,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'biometricEnabled': biometricEnabled,
    'pretendMode': pretendMode?.toJson(),
    'voiceKeyword': voiceKeyword?.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    photoUrl: json['photoUrl'] as String?,
    biometricEnabled: json['biometricEnabled'] as bool? ?? false,
    pretendMode: json['pretendMode'] != null
        ? PretendModeConfig.fromJson(json['pretendMode'] as Map<String, dynamic>)
        : null,
    voiceKeyword: json['voiceKeyword'] != null
        ? VoiceKeywordConfig.fromJson(json['voiceKeyword'] as Map<String, dynamic>)
        : null,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoUrl,
    biometricEnabled,
    pretendMode,
    voiceKeyword,
    createdAt,
    updatedAt,
  ];
}
