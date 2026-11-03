// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(auth)
final authProvider = AuthProvider._();

final class AuthProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return auth(ref);
  }
}

String _$authHash() => r'b11a8d18935ada4bdcaf2f916aa495ce73c959ac';

/// Auth-Aktionen. `isLoading` ist true, solange eine Aktion läuft.
/// Fehler werden an den Aufrufer weitergegeben, der sie anzeigt.

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// Auth-Aktionen. `isLoading` ist true, solange eine Aktion läuft.
/// Fehler werden an den Aufrufer weitergegeben, der sie anzeigt.
final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, void> {
  /// Auth-Aktionen. `isLoading` ist true, solange eine Aktion läuft.
  /// Fehler werden an den Aufrufer weitergegeben, der sie anzeigt.
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'6bf5ebb06eb491cc6b9548d02af586ed5140ec42';

/// Auth-Aktionen. `isLoading` ist true, solange eine Aktion läuft.
/// Fehler werden an den Aufrufer weitergegeben, der sie anzeigt.

abstract class _$AuthController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
