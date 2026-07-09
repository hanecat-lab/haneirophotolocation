import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/models/output_profile.dart';
import '../../domain/repositories/output_profile_repository.dart';
import 'isar_output_profile_repository.dart';

part 'output_profile_repository_provider.g.dart';

@Riverpod(keepAlive: true)
OutputProfileRepository outputProfileRepository(Ref ref) =>
    IsarOutputProfileRepository(ref.watch(isarProvider));

/// All output profiles, for the profile-driven copy menu.
@riverpod
Future<List<OutputProfile>> outputProfiles(Ref ref) {
  return ref.watch(outputProfileRepositoryProvider).fetchAll();
}
