import 'package:isar_community/isar.dart';

import '../models/output_profile.dart';

abstract class OutputProfileRepository {
  Future<List<OutputProfile>> fetchAll();

  Future<OutputProfile?> fetchByProfileId(String profileId);

  Future<Id> save(OutputProfile profile);
}
