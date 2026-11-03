import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

part 'auth_provider.g.dart';

@riverpod
Stream<AuthState> auth(Ref ref) {
  return supabase.auth.onAuthStateChange;
}

/// Auth-Aktionen. `isLoading` ist true, solange eine Aktion läuft.
/// Fehler werden an den Aufrufer weitergegeben, der sie anzeigt.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) {
    return _run(() => supabase.auth.signInWithPassword(email: email.trim(), password: password));
  }

  Future<void> signUp({required String email, required String password}) {
    return _run(() async {
      final response = await supabase.auth.signUp(email: email.trim(), password: password);
      if (response.user == null) throw AuthException('An unknown error occurred');
    });
  }

  Future<void> signOut() => _run(() => supabase.auth.signOut());

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
    } finally {
      state = const AsyncData(null);
    }
  }
}
