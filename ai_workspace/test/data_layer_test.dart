@TestOn('vm')
library;

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ai_workspace/core/database/isar_database.dart';
import 'package:ai_workspace/features/profile/data/repositories/isar_output_profile_repository.dart';
import 'package:ai_workspace/features/workspace/data/repositories/isar_workspace_repository.dart';
import 'package:ai_workspace/features/workspace/domain/models/workspace_item.dart';
import 'package:ai_workspace/features/workspace/domain/models/workspace_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Directory tempDir;
  late Isar isar;

  setUpAll(() async {
    // Use the native library bundled in isar_community_flutter_libs instead
    // of downloading it (the download host is not reachable from CI).
    // Tests run with cwd = package root, so resolve it via package_config.
    final packageConfig = jsonDecode(
      File('.dart_tool/package_config.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final package = (packageConfig['packages'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['name'] == 'isar_community_flutter_libs');
    final packageRoot = Uri.parse(package['rootUri'] as String).isAbsolute
        ? Uri.parse(package['rootUri'] as String).toFilePath()
        : File('.dart_tool/${package['rootUri']}').resolveSymbolicLinksSync();
    final library = Platform.isLinux
        ? '$packageRoot/linux/libisar.so'
        : Platform.isMacOS
            ? '$packageRoot/macos/libisar.dylib'
            : '$packageRoot\\windows\\libisar.dll';
    await Isar.initializeIsarCore(libraries: {Abi.current(): library});
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_test_');
    isar = await Isar.open(
      IsarDatabase.schemas,
      directory: tempDir.path,
      name: 'test_${DateTime.now().microsecondsSinceEpoch}',
      inspector: false,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    await tempDir.delete(recursive: true);
  });

  group('IsarWorkspaceRepository', () {
    test('saves and fetches items sorted by createdAt desc', () async {
      final repo = IsarWorkspaceRepository(isar);

      final older = WorkspaceItem()
        ..title = 'older'
        ..role = WorkspaceItemRole.input
        ..createdAt = DateTime(2026, 1, 1);
      final newer = WorkspaceItem()
        ..title = 'newer'
        ..role = WorkspaceItemRole.input
        ..createdAt = DateTime(2026, 6, 1);
      await repo.saveItem(older);
      await repo.saveItem(newer);

      final items = await repo.fetchAllItems();
      expect(items.map((i) => i.title).toList(), ['newer', 'older']);
    });

    test('sourceItem link and derivedItems backlink stay consistent',
        () async {
      final repo = IsarWorkspaceRepository(isar);

      final source = WorkspaceItem()
        ..title = 'OCR source'
        ..content = 'raw'
        ..role = WorkspaceItemRole.input;
      await repo.saveItem(source);

      final finalized = WorkspaceItem()
        ..title = 'finalized'
        ..content = 'cleaned'
        ..role = WorkspaceItemRole.finalized;
      finalized.sourceItem.value = source;
      await repo.saveItem(finalized);

      final fetchedFinalized = await repo.fetchItem(finalized.id);
      expect(fetchedFinalized!.sourceItem.value!.id, source.id);

      final fetchedSource = await repo.fetchItem(source.id);
      expect(
        fetchedSource!.derivedItems.map((i) => i.id),
        contains(finalized.id),
      );
    });

    test('saveLog wires both link directions and fetchLogsForItem returns it',
        () async {
      final repo = IsarWorkspaceRepository(isar);

      final item = WorkspaceItem()
        ..title = 'item'
        ..role = WorkspaceItemRole.input;
      await repo.saveItem(item);

      final log = WorkspaceLog()
        ..action = WorkspaceLogAction.ocr
        ..description = 'Extracted text from image';
      log.workspaceItem.value = item;
      await repo.saveLog(log);

      final logs = await repo.fetchLogsForItem(item.id);
      expect(logs, hasLength(1));
      expect(logs.first.action, WorkspaceLogAction.ocr);
      expect(logs.first.description, 'Extracted text from image');
    });

    test('deleteItem removes the item and its logs', () async {
      final repo = IsarWorkspaceRepository(isar);

      final item = WorkspaceItem()
        ..title = 'to delete'
        ..role = WorkspaceItemRole.input;
      await repo.saveItem(item);
      final log = WorkspaceLog()..action = WorkspaceLogAction.create;
      log.workspaceItem.value = item;
      await repo.saveLog(log);

      expect(await repo.deleteItem(item.id), isTrue);
      expect(await repo.fetchItem(item.id), isNull);
      expect(await isar.workspaceLogs.count(), 0);
    });
  });

  group('OutputProfile seeding and repository', () {
    test('seedDefaultOutputProfiles inserts defaults exactly once', () async {
      await IsarDatabase.seedDefaultOutputProfiles(isar);
      await IsarDatabase.seedDefaultOutputProfiles(isar);

      final repo = IsarOutputProfileRepository(isar);
      final profiles = await repo.fetchAll();
      expect(profiles, hasLength(3));
      expect(
        profiles.map((p) => p.profileId),
        containsAll(['plain_text', 'markdown_spec', 'json_summary']),
      );
    });

    test('fetchByProfileId resolves a profile by its unique id', () async {
      await IsarDatabase.seedDefaultOutputProfiles(isar);
      final repo = IsarOutputProfileRepository(isar);

      final markdown = await repo.fetchByProfileId('markdown_spec');
      expect(markdown, isNotNull);
      expect(markdown!.formatType, 'markdown');
      expect(markdown.templateText, contains('{{content}}'));
    });
  });
}
