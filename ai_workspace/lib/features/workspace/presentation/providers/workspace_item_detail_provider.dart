import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/workspace_repository_provider.dart';
import '../../domain/models/workspace_item.dart';
import '../../domain/models/workspace_log.dart';

part 'workspace_item_detail_provider.g.dart';

@riverpod
Future<WorkspaceItem?> workspaceItemDetail(
  Ref ref,
  int itemId,
) {
  return ref.watch(workspaceRepositoryProvider).fetchItem(itemId);
}

@riverpod
Future<List<WorkspaceLog>> workspaceItemLogs(
  Ref ref,
  int itemId,
) {
  return ref.watch(workspaceRepositoryProvider).fetchLogsForItem(itemId);
}
