import 'package:isar_community/isar.dart';

import '../models/workspace_item.dart';
import '../models/workspace_log.dart';

/// Persistence boundary for workspace items and their activity logs.
abstract class WorkspaceRepository {
  Future<List<WorkspaceItem>> fetchAllItems();

  Future<WorkspaceItem?> fetchItem(Id id);

  /// Saves the item (insert or update) including its links
  /// (sourceItem / logs), and returns the item id.
  Future<Id> saveItem(WorkspaceItem item);

  /// Deletes the item, its logs, and returns whether it existed.
  /// Does NOT delete the stored file; callers release it via StorageService.
  Future<bool> deleteItem(Id id);

  /// Saves a log entry and wires it to its item (both link directions).
  Future<Id> saveLog(WorkspaceLog log);

  Future<List<WorkspaceLog>> fetchLogsForItem(Id itemId);
}
