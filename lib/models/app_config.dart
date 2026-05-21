import 'package:equatable/equatable.dart';
import 'pretend_mode_config.dart';
import 'fake_call_config.dart';
import 'sos_gesture_config.dart';

class AppConfig extends Equatable {
  final String version;
  final PretendModeConfig pretendMode;
  final FakeCallConfig fakeCall;
  final SosGestureConfig sosGestures;

  const AppConfig({
    required this.version,
    required this.pretendMode,
    required this.fakeCall,
    required this.sosGestures,
  });

  Map<String, dynamic> toJson() => {
    'version': version,
    'pretendMode': pretendMode.toJson(),
    'fakeCall': fakeCall.toJson(),
    'sosGestures': sosGestures.toJson(),
  };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    version: json['version'] as String,
    pretendMode: PretendModeConfig.fromJson(json['pretendMode'] as Map<String, dynamic>),
    fakeCall: FakeCallConfig.fromJson(json['fakeCall'] as Map<String, dynamic>),
    sosGestures: SosGestureConfig.fromJson(json['sosGestures'] as Map<String, dynamic>),
  );

  @override
  List<Object?> get props => [version, pretendMode, fakeCall, sosGestures];
}
