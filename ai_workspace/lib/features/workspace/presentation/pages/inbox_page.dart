import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/workspace_item.dart';
import '../providers/workspace_list_notifier.dart';
import '../widgets/role_badge.dart';
import 'item_edit_page.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(workspaceListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Workspace')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorView(
          error: error,
          onRetry: () => ref.invalidate(workspaceListProvider),
        ),
        data: (items) => items.isEmpty
            ? const _EmptyView()
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    _ItemTile(item: items[index]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('カメラで撮影してOCR'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickAndOcr(context, ref, ImageSource.camera);
                },
              ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(kIsWeb ? '画像を取り込む（OCRはモバイルのみ）' : '画像を選択してOCR'),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickAndOcr(context, ref, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields_outlined),
              title: const Text('テキストを追加'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showAddTextDialog(context, ref);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndOcr(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);
    if (picked == null) return;
    await ref.read(workspaceListProvider.notifier).processOcr(picked);
  }

  Future<void> _showAddTextDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final textController = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('テキストを追加'),
        content: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'タイトル（省略可）'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: '本文'),
                minLines: 4,
                maxLines: 10,
                autofocus: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('追加'),
          ),
        ],
      ),
    );
    if (saved == true && textController.text.trim().isNotEmpty) {
      await ref.read(workspaceListProvider.notifier).addTextItem(
            title: titleController.text.trim(),
            text: textController.text,
          );
    }
    titleController.dispose();
    textController.dispose();
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item});

  final WorkspaceItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippet = (item.content ?? '').replaceAll('\n', ' ');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(roleIcon(item.role)),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (snippet.isNotEmpty)
              Text(snippet, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                RoleBadge(role: item.role),
                const SizedBox(width: 8),
                if (item.fileKey != null) ...[
                  const Icon(Icons.attachment, size: 14),
                  const SizedBox(width: 8),
                ],
                Text(
                  _formatDate(item.createdAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => ItemEditPage(itemId: item.id),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}/${two(dt.month)}/${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.workspaces_outline,
              size: 56, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('アイテムがありません'),
          const SizedBox(height: 4),
          Text(
            '右下の＋から画像OCRまたはテキストを追加',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text('$error', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('再読み込み')),
          ],
        ),
      ),
    );
  }
}
