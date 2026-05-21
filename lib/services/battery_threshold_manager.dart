enum BatteryLevel { normal, low, critical, veryLow }

class BatteryThresholdManager {
  static const int lowThreshold = 20;
  static const int criticalThreshold = 10;
  static const int veryLowThreshold = 5;

  BatteryLevel classify(int percent) {
    if (percent <= veryLowThreshold) return BatteryLevel.veryLow;
    if (percent <= criticalThreshold) return BatteryLevel.critical;
    if (percent <= lowThreshold) return BatteryLevel.low;
    return BatteryLevel.normal;
  }

  /// Returns the recommended location update interval in milliseconds.
  int locationIntervalMs(int percent) {
    if (percent < lowThreshold) return 30000; // 30 seconds
    return 10000; // 10 seconds (normal)
  }

  bool shouldNotifyContacts(int percent) => percent <= criticalThreshold;
  bool shouldSendFinalLocation(int percent) => percent <= veryLowThreshold;
}
