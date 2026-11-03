import 'dart:io';
import 'package:flutter/material.dart';
import 'package:voc_trainer/utils/special_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension ErrorSnackbar on BuildContext {
  void showError(Object e) {
    final msg = switch (e) {
      SpecialException() => (e).errorMessage,
      AuthException() => _translateAuthError(e),
      PostgrestException() => _translatePostgrestError((e).code),
      SocketException() || HttpException() => 'Network error. Please check your connection.',
      _ => 'An unexpected error occurred.',
    };
    debugPrint(e.toString());
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _translateAuthError(AuthException e) => switch (e.message) {
    String m
        when m.contains('already registered') ||
            m.contains('already exists') ||
            m.contains('already in use') ||
            m.contains('already been registered') =>
      'This email address is already taken.',

    String m when m.contains('Password should be at least') =>
      'The password must be at least 6 characters long.',

    String m when m.contains('weak_password') => 'Password is too weak.',

    String m when m.contains('New password should be different') =>
      'The new password must be different from the old one.',

    String m when m.contains('Email not confirmed') => 'Your email has not been confirmed yet.',

    String m when m.contains('Unable to validate email address') => 'Invalid email address.',

    String m when m.contains('Email address') && m.contains('is invalid') =>
      'Invalid email address.',

    _ => switch (e.statusCode) {
      '400' => 'Wrong email or password.',
      '422' => 'Invalid input.',
      '429' => 'Too many attempts. Please wait a moment.',
      _ => 'Authentication error. Please try again.',
    },
  };

  String _translatePostgrestError(String? code) => switch (code) {
    'P0001' => 'Action not allowed.',
    '23505' => 'This entry already exists.',
    '23503' => 'The referenced entry does not exist.',
    '42501' => 'You do not have permission for this action.',
    _ => 'A database error occurred.',
  };
}
