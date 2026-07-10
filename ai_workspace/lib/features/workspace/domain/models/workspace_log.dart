import 'package:isar_community/isar.dart';

import 'workspace_item.dart';

part 'workspace_log.g.dart';

/// Activity tracker: every meaningful action on an item is recorded
/// automatically so the workspace doubles as an audit trail.
@collection
class WorkspaceLog {
  Id id = Isar.autoIncrement;

  @Index()
  DateTime executedAt = DateTime.now();

  @enumerated
  late WorkspaceLogAction action;

  String? description; // e.g., "Copied as Markdown", "Connection failed: Over quota"

  final workspaceItem = IsarLink<WorkspaceItem>();
}

enum WorkspaceLogAction {
  create,
  edit,
  ocr,
  copy,
  aiInference,
  workflowRun,
}
