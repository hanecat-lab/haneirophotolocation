// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The opened Isar instance. Initialized in main() before runApp and
/// injected via ProviderScope overrides, so every consumer can assume a
/// ready connection.

@ProviderFor(isar)
final isarProvider = IsarProvider._();

/// The opened Isar instance. Initialized in main() before runApp and
/// injected via ProviderScope overrides, so every consumer can assume a
/// ready connection.

final class IsarProvider extends $FunctionalProvider<Isar, Isar, Isar>
    with $Provider<Isar> {
  /// The opened Isar instance. Initialized in main() before runApp and
  /// injected via ProviderScope overrides, so every consumer can assume a
  /// ready connection.
  IsarProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'isarProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$isarHash();

  @$internal
  @override
  $ProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Isar create(Ref ref) {
    return isar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Isar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Isar>(value),
    );
  }
}

String _$isarHash() => r'b5baa209b0ef04451865a826c7a9adb818d99172';
