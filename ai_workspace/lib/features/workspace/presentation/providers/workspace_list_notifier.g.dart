// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkspaceListNotifier)
final workspaceListProvider = WorkspaceListNotifierProvider._();

final class WorkspaceListNotifierProvider
    extends $AsyncNotifierProvider<WorkspaceListNotifier, List<WorkspaceItem>> {
  WorkspaceListNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'workspaceListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$workspaceListNotifierHash();

  @$internal
  @override
  WorkspaceListNotifier create() => WorkspaceListNotifier();
}

String _$workspaceListNotifierHash() =>
    r'46113e3e417927467ab5152b1d94e8a772976f58';

abstract class _$WorkspaceListNotifier
    extends $AsyncNotifier<List<WorkspaceItem>> {
  FutureOr<List<WorkspaceItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WorkspaceItem>>, List<WorkspaceItem>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<WorkspaceItem>>, List<WorkspaceItem>>,
        AsyncValue<List<WorkspaceItem>>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
