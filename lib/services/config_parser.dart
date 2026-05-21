import 'dart:convert';
import '../models/app_config.dart';

class ConfigParseError {
  final String message;
  const ConfigParseError(this.message);
}

class ConfigParser {
  /// Parse a JSON string into an [AppConfig].
  /// Returns null and sets [error] if parsing fails.
  static ({AppConfig? config, ConfigParseError? error}) parse(String jsonString) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final config = AppConfig.fromJson(map);
      return (config: config, error: null);
    } catch (e) {
      return (config: null, error: ConfigParseError('Invalid config: $e'));
    }
  }

  /// Format an [AppConfig] to a JSON string.
  static String format(AppConfig config) {
    return jsonEncode(config.toJson());
  }
}
