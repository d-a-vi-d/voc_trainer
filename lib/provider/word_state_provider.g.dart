// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WordStateNotifier)
final wordStateProvider = WordStateNotifierProvider._();

final class WordStateNotifierProvider
    extends $AsyncNotifierProvider<WordStateNotifier, WordState> {
  WordStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordStateNotifierHash();

  @$internal
  @override
  WordStateNotifier create() => WordStateNotifier();
}

String _$wordStateNotifierHash() => r'e285d96232c435fcdd88a07311ed9fb2f5e0eba5';

abstract class _$WordStateNotifier extends $AsyncNotifier<WordState> {
  FutureOr<WordState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WordState>, WordState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WordState>, WordState>,
              AsyncValue<WordState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
