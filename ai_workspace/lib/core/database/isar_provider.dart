import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_provider.g.dart';

/// The opened Isar instance. Initialized in main() before runApp and
/// injected via ProviderScope overrides, so every consumer can assume a
/// ready connection.
@Riverpod(keepAlive: true)
Isar isar(Ref ref) {
  throw UnimplementedError(
    'isarProvider must be overridden in ProviderScope (see main.dart)',
  );
}
