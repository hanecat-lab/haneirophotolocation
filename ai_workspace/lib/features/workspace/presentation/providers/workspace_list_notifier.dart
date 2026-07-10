import 'dart:convert';

import 'package:cross_file/cross_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/clipboard_util.dart';
import '../../../../core/utils/storage_service_provider.dart';
import '../../../../core/utils/template_renderer.dart';
import '../../../profile/domain/models/output_profile.dart';
import '../../application/ocr_service.dart';
import '../../application/ocr_service_provider.dart';
import '../../data/repositories/workspace_repository_provider.dart';
import '../../domain/models/workspace_item.dart';
import '../../domain/models/workspace_log.dart';

part 'workspace_list_notifier.g.dart';

@riverpod
class WorkspaceListNotifier extends _$WorkspaceListNotifier {
  @override
  FutureOr<List<WorkspaceItem>> build() async {
    final repository = ref.watch(workspaceRepositoryProvider);
    return repository.fetchAllItems();
  }

  /// Core Phase 1 flow: image -> OCR -> persist file via StorageService ->
  /// save WorkspaceItem -> auto log.
  Future<void> processOcr(XFile imageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final ocrService = ref.read(ocrServiceProvider);
      final storageService = ref.read(storageServiceProvider);
      final repository = ref.read(workspaceRepositoryProvider);

      // 1. Persist the media file first so it is never lost, even when OCR
      //    is unavailable (web) or fails midway.
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.name.isNotEmpty
          ? imageFile.name
          : 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fileKey = await storageService.saveFile(bytes, fileName);

      // 2. Process OCR
      final stopwatch = Stopwatch()..start();
      String extractedText = '';
      String? ocrError;
      try {
        extractedText = await ocrService.extractText(imageFile);
      } on OcrUnsupportedException catch (e) {
        ocrError = e.message;
      }
      stopwatch.stop();

      // 3. Save WorkspaceItem
      final item = WorkspaceItem()
        ..title = 'OCR_${DateTime.now().millisecondsSinceEpoch}'
        ..rawContent = extractedText
        ..content = extractedText
        ..role = WorkspaceItemRole.input
        ..fileKey = fileKey
        ..metadataJson = jsonEncode({
          'source': 'image',
          'fileName': fileName,
          'fileSize': bytes.length,
          'ocrDurationMs': stopwatch.elapsedMilliseconds,
          if (ocrError != null) 'ocrError': ocrError,
        });
      await repository.saveItem(item);

      // 4. Record activity log
      final log = WorkspaceLog()
        ..action = WorkspaceLogAction.ocr
        ..description = ocrError == null
            ? 'Extracted text from image ($fileName)'
            : 'Image stored without OCR: $ocrError';
      log.workspaceItem.value = item;
      await repository.saveLog(log);

      return repository.fetchAllItems();
    });
  }

  /// Text input flow (no image): create an item directly from pasted text.
  Future<void> addTextItem({required String title, required String text}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workspaceRepositoryProvider);

      final item = WorkspaceItem()
        ..title = title.isEmpty
            ? 'TEXT_${DateTime.now().millisecondsSinceEpoch}'
            : title
        ..rawContent = text
        ..content = text
        ..role = WorkspaceItemRole.input
        ..metadataJson = jsonEncode({'source': 'text'});
      await repository.saveItem(item);

      final log = WorkspaceLog()
        ..action = WorkspaceLogAction.create
        ..description = 'Created from text input';
      log.workspaceItem.value = item;
      await repository.saveLog(log);

      return repository.fetchAllItems();
    });
  }

  /// Edit flow: update title/content and auto-log the edit.
  Future<void> updateItem(
    WorkspaceItem item, {
    required String title,
    required String content,
  }) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workspaceRepositoryProvider);

      item
        ..title = title
        ..content = content;
      await repository.saveItem(item);

      final log = WorkspaceLog()
        ..action = WorkspaceLogAction.edit
        ..description = 'Edited content';
      log.workspaceItem.value = item;
      await repository.saveLog(log);

      return repository.fetchAllItems();
    });
  }

  /// Output-profile driven copy: renders the profile template and copies the
  /// result to the clipboard, then auto-logs which profile was used.
  Future<String> copyWithProfile(
    WorkspaceItem item,
    OutputProfile profile,
  ) async {
    final rendered = renderTemplate(
      profile.templateText,
      title: item.title,
      content: item.content ?? '',
      rawContent: item.rawContent ?? '',
    );
    await ClipboardUtil.copyText(rendered);

    final repository = ref.read(workspaceRepositoryProvider);
    final log = WorkspaceLog()
      ..action = WorkspaceLogAction.copy
      ..description = 'Copied as ${profile.name} (${profile.profileId})';
    log.workspaceItem.value = item;
    await repository.saveLog(log);
    return rendered;
  }

  /// Knowledge-graph flow: create a finalized item derived from [source].
  /// The new item keeps a sourceItem link so origin -> deliverable stays
  /// traceable.
  Future<void> finalizeItem(WorkspaceItem source) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workspaceRepositoryProvider);

      final finalized = WorkspaceItem()
        ..title = '${source.title}（確定版）'
        ..content = source.content
        ..rawContent = source.rawContent
        ..role = WorkspaceItemRole.finalized
        ..metadataJson = jsonEncode({'source': 'finalize', 'sourceItemId': source.id});
      finalized.sourceItem.value = source;
      await repository.saveItem(finalized);

      final log = WorkspaceLog()
        ..action = WorkspaceLogAction.create
        ..description = 'Finalized from "${source.title}"';
      log.workspaceItem.value = finalized;
      await repository.saveLog(log);

      return repository.fetchAllItems();
    });
  }

  /// Deletes the item, its logs, and its stored file (if any).
  Future<void> deleteItem(WorkspaceItem item) async {
    state = await AsyncValue.guard(() async {
      final repository = ref.read(workspaceRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      final fileKey = item.fileKey;
      await repository.deleteItem(item.id);
      if (fileKey != null) {
        await storageService.deleteFile(fileKey);
      }
      return repository.fetchAllItems();
    });
  }
}
