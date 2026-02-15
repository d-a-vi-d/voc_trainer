import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voc_trainer/screens/login_screen.dart';
import 'package:voc_trainer/screens/signup_screen.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in with Email and Password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Sign up with Email and Password
  Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();

      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      print("Logout error $e");
    }
    isLoggedIn = false;
  }
}
