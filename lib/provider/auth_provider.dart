import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<AuthState> auth(Ref ref) {
  return supabase.auth.onAuthStateChange;
}
