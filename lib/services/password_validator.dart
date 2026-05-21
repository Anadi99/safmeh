class PasswordValidator {
  /// Returns null if valid, or an error message if invalid.
  static String? validate(String password) {
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (!password.contains(RegExp(r'[A-Z]'))) return 'Password must contain at least one uppercase letter.';
    if (!password.contains(RegExp(r'[a-z]'))) return 'Password must contain at least one lowercase letter.';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Password must contain at least one number.';
    return null;
  }

  static bool isValid(String password) => validate(password) == null;
}
