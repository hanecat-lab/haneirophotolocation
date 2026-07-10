import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/repositories/workspace_repository.dart';
import 'isar_workspace_repository.dart';

part 'workspace_repository_provider.g.dart';

@Riverpod(keepAlive: true)
WorkspaceRepository workspaceRepository(Ref ref) =>
    IsarWorkspaceRepository(ref.watch(isarProvider));
