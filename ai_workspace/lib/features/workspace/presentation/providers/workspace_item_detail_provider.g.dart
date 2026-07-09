// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_item_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workspaceItemDetail)
final workspaceItemDetailProvider = WorkspaceItemDetailFamily._();

final class WorkspaceItemDetailProvider extends $FunctionalProvider<
        AsyncValue<WorkspaceItem?>, WorkspaceItem?, FutureOr<WorkspaceItem?>>
    with $FutureModifier<WorkspaceItem?>, $FutureProvider<WorkspaceItem?> {
  WorkspaceItemDetailProvider._(
      {required WorkspaceItemDetailFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'workspaceItemDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$workspaceItemDetailHash();

  @override
  String toString() {
    return r'workspaceItemDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkspaceItem?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WorkspaceItem?> create(Ref ref) {
    final argument = this.argument as int;
    return workspaceItemDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceItemDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workspaceItemDetailHash() =>
    r'a037b7cbfe05e26047905706ea7e86b129c50bef';

final class WorkspaceItemDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkspaceItem?>, int> {
  WorkspaceItemDetailFamily._()
      : super(
          retry: null,
          name: r'workspaceItemDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WorkspaceItemDetailProvider call(
    int itemId,
  ) =>
      WorkspaceItemDetailProvider._(argument: itemId, from: this);

  @override
  String toString() => r'workspaceItemDetailProvider';
}

@ProviderFor(workspaceItemLogs)
final workspaceItemLogsProvider = WorkspaceItemLogsFamily._();

final class WorkspaceItemLogsProvider extends $FunctionalProvider<
        AsyncValue<List<WorkspaceLog>>,
        List<WorkspaceLog>,
        FutureOr<List<WorkspaceLog>>>
    with
        $FutureModifier<List<WorkspaceLog>>,
        $FutureProvider<List<WorkspaceLog>> {
  WorkspaceItemLogsProvider._(
      {required WorkspaceItemLogsFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'workspaceItemLogsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$workspaceItemLogsHash();

  @override
  String toString() {
    return r'workspaceItemLogsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WorkspaceLog>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkspaceLog>> create(Ref ref) {
    final argument = this.argument as int;
    return workspaceItemLogs(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceItemLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workspaceItemLogsHash() => r'0b6ce0126a1e3f7d64af01ae48a002097d60ee37';

final class WorkspaceItemLogsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WorkspaceLog>>, int> {
  WorkspaceItemLogsFamily._()
      : super(
          retry: null,
          name: r'workspaceItemLogsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  WorkspaceItemLogsProvider call(
    int itemId,
  ) =>
      WorkspaceItemLogsProvider._(argument: itemId, from: this);

  @override
  String toString() => r'workspaceItemLogsProvider';
}
