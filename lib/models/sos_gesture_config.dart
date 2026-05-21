import 'package:equatable/equatable.dart';

class SosGestureConfig extends Equatable {
  final bool powerButtonEnabled;
  final bool shakeEnabled;
  final bool volumePatternEnabled;
  final bool voiceKeywordEnabled;
  final String? voiceKeyword;

  const SosGestureConfig({
    this.powerButtonEnabled = true,
    this.shakeEnabled = true,
    this.volumePatternEnabled = true,
    this.voiceKeywordEnabled = false,
    this.voiceKeyword,
  });

  Map<String, dynamic> toJson() => {
    'powerButtonEnabled': powerButtonEnabled,
    'shakeEnabled': shakeEnabled,
    'volumePatternEnabled': volumePatternEnabled,
    'voiceKeywordEnabled': voiceKeywordEnabled,
    'voiceKeyword': voiceKeyword,
  };

  factory SosGestureConfig.fromJson(Map<String, dynamic> json) => SosGestureConfig(
    powerButtonEnabled: json['powerButtonEnabled'] as bool? ?? true,
    shakeEnabled: json['shakeEnabled'] as bool? ?? true,
    volumePatternEnabled: json['volumePatternEnabled'] as bool? ?? true,
    voiceKeywordEnabled: json['voiceKeywordEnabled'] as bool? ?? false,
    voiceKeyword: json['voiceKeyword'] as String?,
  );

  @override
  List<Object?> get props => [
    powerButtonEnabled,
    shakeEnabled,
    volumePatternEnabled,
    voiceKeywordEnabled,
    voiceKeyword,
  ];
}
