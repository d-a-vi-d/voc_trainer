const _minPasswordLength = 6;

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Please enter your email.';
  if (!_emailPattern.hasMatch(email)) return 'Invalid email address.';
  return null;
}

/// Login: only check that something was entered. Supabase decides if it is correct.
String? validateLoginPassword(String? value) {
  if (value == null || value.isEmpty) return 'Please enter your password.';
  return null;
}

/// Signup: minimum length (Supabase default is 6).
String? validateNewPassword(String? value) {
  if (value == null || value.length < _minPasswordLength) {
    return 'The password must be at least $_minPasswordLength characters long.';
  }
  return null;
}
