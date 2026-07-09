import 'package:isar_community/isar.dart';

import 'workspace_log.dart';

part 'workspace_item.g.dart';

/// The smallest unit of knowledge in the workspace.
///
/// Inputs (OCR results, pasted text), AI responses, and finalized texts are
/// all represented equally as [WorkspaceItem]s so that every piece of
/// information stays reusable as an asset.
@collection
class WorkspaceItem {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  String title = '';
  String? content; // Main text after cleaning/editing
  String? rawContent; // Raw text immediately after OCR/import

  @enumerated
  late WorkspaceItemRole role;

  // Dynamic properties for future proofing (JSON string)
  // e.g., {"source": "image", "fileSize": 1024, "ocrDurationMs": 450}
  String? metadataJson;

  // Key to retrieve files via StorageService (abstracted for Web/Mobile support)
  String? fileKey;

  // Knowledge Graph relationships
  final sourceItem = IsarLink<WorkspaceItem>(); // Link to the original source item

  @Backlink(to: 'sourceItem')
  final derivedItems = IsarLinks<WorkspaceItem>(); // Items derived from this item

  final logs = IsarLinks<WorkspaceLog>();
}

enum WorkspaceItemRole {
  input,
  aiResponse,
  finalized,
  template,
}
