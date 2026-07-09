import 'package:isar_community/isar.dart';

import '../../domain/models/output_profile.dart';
import '../../domain/repositories/output_profile_repository.dart';

class IsarOutputProfileRepository implements OutputProfileRepository {
  IsarOutputProfileRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<OutputProfile>> fetchAll() {
    return _isar.outputProfiles.where().findAll();
  }

  @override
  Future<OutputProfile?> fetchByProfileId(String profileId) {
    return _isar.outputProfiles
        .filter()
        .profileIdEqualTo(profileId)
        .findFirst();
  }

  @override
  Future<Id> save(OutputProfile profile) {
    profile.updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.outputProfiles.put(profile));
  }
}
