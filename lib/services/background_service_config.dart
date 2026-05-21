/// Configuration constants for the background service.
class BackgroundServiceConfig {
  /// Android foreground notification channel ID.
  static const String notificationChannelId = 'safmeh_background';

  /// Android foreground notification channel name.
  static const String notificationChannelName = 'SafMeh Protection';

  /// Android foreground notification ID.
  static const int notificationId = 888;

  /// Background location update interval in milliseconds (normal mode).
  static const int locationIntervalNormalMs = 10000;

  /// Background location update interval in milliseconds (battery saver mode).
  static const int locationIntervalBatterySaverMs = 30000;

  /// Sensor sampling interval in milliseconds.
  static const int sensorSamplingIntervalMs = 100;
}
