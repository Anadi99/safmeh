import 'package:equatable/equatable.dart';

enum DecoyAppType { calculator, notes, journal, music }

class PretendModeConfig extends Equatable {
  final String secretPin;
  final DecoyAppType decoyType;

  const PretendModeConfig({
    required this.secretPin,
    required this.decoyType,
  });

  Map<String, dynamic> toJson() => {
    'secretPin': secretPin,
    'decoyType': decoyType.name,
  };

  factory PretendModeConfig.fromJson(Map<String, dynamic> json) => PretendModeConfig(
    secretPin: json['secretPin'] as String,
    decoyType: DecoyAppType.values.byName(json['decoyType'] as String),
  );

  @override
  List<Object?> get props => [secretPin, decoyType];
}
