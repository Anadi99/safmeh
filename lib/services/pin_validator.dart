class PinValidator {
  /// Returns true if [input] exactly matches [configuredPin].
  static bool validate(String input, String configuredPin) {
    return input == configuredPin;
  }
}
