import 'package:isar_community/isar.dart';

import '../../domain/models/workspace_item.dart';
import '../../domain/models/workspace_log.dart';
import '../../domain/repositories/workspace_repository.dart';

class IsarWorkspaceRepository implements WorkspaceRepository {
  IsarWorkspaceRepository(this._isar);

  final Isar _isar;

  @override
  Future<List<WorkspaceItem>> fetchAllItems() async {
    final items =
        await _isar.workspaceItems.where().sortByCreatedAtDesc().findAll();
    for (final item in items) {
      await item.sourceItem.load();
    }
    return items;
  }

  @override
  Future<WorkspaceItem?> fetchItem(Id id) async {
    final item = await _isar.workspaceItems.get(id);
    if (item != null) {
      await item.sourceItem.load();
      await item.derivedItems.load();
      await item.logs.load();
    }
    return item;
  }

  @override
  Future<Id> saveItem(WorkspaceItem item) async {
    item.updatedAt = DateTime.now();
    return _isar.writeTxn(() async {
      final id = await _isar.workspaceItems.put(item);
      await item.sourceItem.save();
      await item.logs.save();
      return id;
    });
  }

  @override
  Future<bool> deleteItem(Id id) async {
    return _isar.writeTxn(() async {
      final item = await _isar.workspaceItems.get(id);
      if (item == null) return false;
      await item.logs.load();
      final logIds = item.logs.map((log) => log.id).toList();
      await _isar.workspaceLogs.deleteAll(logIds);
      return _isar.workspaceItems.delete(id);
    });
  }

  @override
  Future<Id> saveLog(WorkspaceLog log) async {
    return _isar.writeTxn(() async {
      final id = await _isar.workspaceLogs.put(log);
      await log.workspaceItem.save();
      final item = log.workspaceItem.value;
      if (item != null) {
        item.logs.add(log);
        await item.logs.save();
      }
      return id;
    });
  }

  @override
  Future<List<WorkspaceLog>> fetchLogsForItem(Id itemId) async {
    final item = await _isar.workspaceItems.get(itemId);
    if (item == null) return [];
    await item.logs.load();
    final logs = item.logs.toList()
      ..sort((a, b) => b.executedAt.compareTo(a.executedAt));
    return logs;
  }
}
