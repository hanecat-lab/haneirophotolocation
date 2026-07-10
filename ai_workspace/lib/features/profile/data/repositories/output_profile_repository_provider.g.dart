// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output_profile_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(outputProfileRepository)
final outputProfileRepositoryProvider = OutputProfileRepositoryProvider._();

final class OutputProfileRepositoryProvider extends $FunctionalProvider<
    OutputProfileRepository,
    OutputProfileRepository,
    OutputProfileRepository> with $Provider<OutputProfileRepository> {
  OutputProfileRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'outputProfileRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outputProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<OutputProfileRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OutputProfileRepository create(Ref ref) {
    return outputProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OutputProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OutputProfileRepository>(value),
    );
  }
}

String _$outputProfileRepositoryHash() =>
    r'f7eb1add8af431473d8c616f881e40709b525571';

/// All output profiles, for the profile-driven copy menu.

@ProviderFor(outputProfiles)
final outputProfilesProvider = OutputProfilesProvider._();

/// All output profiles, for the profile-driven copy menu.

final class OutputProfilesProvider extends $FunctionalProvider<
        AsyncValue<List<OutputProfile>>,
        List<OutputProfile>,
        FutureOr<List<OutputProfile>>>
    with
        $FutureModifier<List<OutputProfile>>,
        $FutureProvider<List<OutputProfile>> {
  /// All output profiles, for the profile-driven copy menu.
  OutputProfilesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'outputProfilesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$outputProfilesHash();

  @$internal
  @override
  $FutureProviderElement<List<OutputProfile>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<OutputProfile>> create(Ref ref) {
    return outputProfiles(ref);
  }
}

String _$outputProfilesHash() => r'5699e9f63a63d3c45c21fc09d24fc79665ded1a3';
