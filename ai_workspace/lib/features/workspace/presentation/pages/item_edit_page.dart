import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/storage_service_provider.dart';
import '../../../profile/data/repositories/output_profile_repository_provider.dart';
import '../../../profile/domain/models/output_profile.dart';
import '../../domain/models/workspace_item.dart';
import '../../domain/models/workspace_log.dart';
import '../providers/workspace_item_detail_provider.dart';
import '../providers/workspace_list_notifier.dart';
import '../widgets/role_badge.dart';

class ItemEditPage extends ConsumerWidget {
  const ItemEditPage({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(workspaceItemDetailProvider(itemId));

    return itemAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('$error')),
      ),
      data: (item) {
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('アイテムが見つかりません（削除済み）')),
          );
        }
        return _ItemEditView(item: item);
      },
    );
  }
}

class _ItemEditView extends ConsumerStatefulWidget {
  const _ItemEditView({required this.item});

  final WorkspaceItem item;

  @override
  ConsumerState<_ItemEditView> createState() => _ItemEditViewState();
}

class _ItemEditViewState extends ConsumerState<_ItemEditView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  WorkspaceItem get item => widget.item;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: item.title);
    _contentController = TextEditingController(text: item.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _refreshDetail() {
    ref.invalidate(workspaceItemDetailProvider(item.id));
    ref.invalidate(workspaceItemLogsProvider(item.id));
  }

  Future<void> _save() async {
    await ref.read(workspaceListProvider.notifier).updateItem(
          item,
          title: _titleController.text.trim(),
          content: _contentController.text,
        );
    _refreshDetail();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('保存しました')));
    }
  }

  Future<void> _copyWithProfile(OutputProfile profile) async {
    await ref
        .read(workspaceListProvider.notifier)
        .copyWithProfile(item, profile);
    _refreshDetail();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('「${profile.name}」形式でコピーしました')),
      );
    }
  }

  Future<void> _finalize() async {
    await ref.read(workspaceListProvider.notifier).finalizeItem(item);
    _refreshDetail();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('確定版を作成しました')));
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('削除しますか？'),
        content: const Text('このアイテムと操作ログ、添付ファイルを削除します。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('削除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(workspaceListProvider.notifier).deleteItem(item);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(outputProfilesProvider);
    final logsAsync = ref.watch(workspaceItemLogsProvider(item.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          profilesAsync.maybeWhen(
            data: (profiles) => PopupMenuButton<OutputProfile>(
              icon: const Icon(Icons.copy_outlined),
              tooltip: '出力プロファイルを選んでコピー',
              onSelected: _copyWithProfile,
              itemBuilder: (context) => [
                for (final profile in profiles)
                  PopupMenuItem(
                    value: profile,
                    child: Text('${profile.name}（${profile.formatType}）'),
                  ),
              ],
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'finalize':
                  _finalize();
                case 'delete':
                  _delete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'finalize',
                child: Text('確定版を作成'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('削除'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              RoleBadge(role: item.role),
              const Spacer(),
              Text(
                '更新: ${_formatDate(item.updatedAt)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'タイトル'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(labelText: '本文'),
            minLines: 8,
            maxLines: 24,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('保存'),
          ),
          if (item.fileKey != null) ...[
            const SizedBox(height: 24),
            Text('添付画像', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _AttachedImage(fileKey: item.fileKey!),
          ],
          if (item.sourceItem.value != null ||
              item.derivedItems.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('関連（ナレッジグラフ）',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            if (item.sourceItem.value != null)
              _RelationTile(
                label: '元アイテム',
                related: item.sourceItem.value!,
              ),
            for (final derived in item.derivedItems)
              _RelationTile(label: '派生アイテム', related: derived),
          ],
          const SizedBox(height: 24),
          Text('操作ログ', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          logsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => Text('$error'),
            data: (logs) => logs.isEmpty
                ? const Text('ログはまだありません')
                : Column(
                    children: [for (final log in logs) _LogTile(log: log)],
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}/${two(dt.month)}/${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _AttachedImage extends ConsumerWidget {
  const _AttachedImage({required this.fileKey});

  final String fileKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    return FutureBuilder<Uint8List?>(
      future: storage.getFile(fileKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final bytes = snapshot.data;
        if (bytes == null) {
          return const Text('画像を読み込めませんでした');
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(bytes, fit: BoxFit.contain),
        );
      },
    );
  }
}

class _RelationTile extends StatelessWidget {
  const _RelationTile({required this.label, required this.related});

  final String label;
  final WorkspaceItem related;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(roleIcon(related.role)),
      title: Text(related.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => ItemEditPage(itemId: related.id),
          ),
        );
      },
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.log});

  final WorkspaceLog log;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(_actionIcon(log.action), size: 20),
      title: Text(log.description ?? _actionLabel(log.action)),
      subtitle: Text(_formatDate(log.executedAt)),
    );
  }

  IconData _actionIcon(WorkspaceLogAction action) {
    switch (action) {
      case WorkspaceLogAction.create:
        return Icons.add_circle_outline;
      case WorkspaceLogAction.edit:
        return Icons.edit_outlined;
      case WorkspaceLogAction.ocr:
        return Icons.document_scanner_outlined;
      case WorkspaceLogAction.copy:
        return Icons.copy_outlined;
      case WorkspaceLogAction.aiInference:
        return Icons.smart_toy_outlined;
      case WorkspaceLogAction.workflowRun:
        return Icons.play_circle_outline;
    }
  }

  String _actionLabel(WorkspaceLogAction action) {
    switch (action) {
      case WorkspaceLogAction.create:
        return '作成';
      case WorkspaceLogAction.edit:
        return '編集';
      case WorkspaceLogAction.ocr:
        return 'OCR';
      case WorkspaceLogAction.copy:
        return 'コピー';
      case WorkspaceLogAction.aiInference:
        return 'AI実行';
      case WorkspaceLogAction.workflowRun:
        return 'ワークフロー実行';
    }
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}/${two(dt.month)}/${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }
}
