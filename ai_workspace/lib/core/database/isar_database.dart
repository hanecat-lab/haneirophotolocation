import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/ai_setting/domain/models/ai_setting.dart';
import '../../features/profile/domain/models/output_profile.dart';
import '../../features/workspace/domain/models/workspace_item.dart';
import '../../features/workspace/domain/models/workspace_log.dart';

/// Isar initialization & connection management.
class IsarDatabase {
  IsarDatabase._();

  static const _instanceName = 'ai_workspace';

  static List<CollectionSchema<dynamic>> get schemas => [
        WorkspaceItemSchema,
        WorkspaceLogSchema,
        AiSettingSchema,
        OutputProfileSchema,
      ];

  /// Opens (or returns the already-open) Isar instance.
  /// On web the directory argument is ignored by Isar.
  static Future<Isar> open() async {
    final existing = Isar.getInstance(_instanceName);
    if (existing != null) return existing;

    String directory = '';
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      directory = dir.path;
    }
    final isar = await Isar.open(
      schemas,
      directory: directory,
      name: _instanceName,
      inspector: false,
    );
    await seedDefaultOutputProfiles(isar);
    return isar;
  }

  /// First-launch seeding: the copy feature is output-profile driven, so a
  /// minimal set of profiles must exist even before the user creates any.
  static Future<void> seedDefaultOutputProfiles(Isar isar) async {
    final count = await isar.outputProfiles.count();
    if (count > 0) return;

    final now = DateTime.now();
    final defaults = [
      OutputProfile()
        ..profileId = 'plain_text'
        ..name = 'プレーンテキスト'
        ..templateText = '{{content}}'
        ..formatType = 'text'
        ..updatedAt = now,
      OutputProfile()
        ..profileId = 'markdown_spec'
        ..name = 'Markdown（見出し付き）'
        ..templateText = '## {{title}}\n\n{{content}}\n'
        ..formatType = 'markdown'
        ..updatedAt = now,
      OutputProfile()
        ..profileId = 'json_summary'
        ..name = 'JSONサマリー'
        ..templateText =
            '{\n  "title": "{{title}}",\n  "content": "{{content}}"\n}'
        ..formatType = 'json'
        ..updatedAt = now,
    ];
    await isar.writeTxn(() async {
      await isar.outputProfiles.putAll(defaults);
    });
  }
}
