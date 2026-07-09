import 'package:flutter/material.dart';

import '../../domain/models/workspace_item.dart';

String roleLabel(WorkspaceItemRole role) {
  switch (role) {
    case WorkspaceItemRole.input:
      return '入力';
    case WorkspaceItemRole.aiResponse:
      return 'AI回答';
    case WorkspaceItemRole.finalized:
      return '確定版';
    case WorkspaceItemRole.template:
      return 'テンプレート';
  }
}

IconData roleIcon(WorkspaceItemRole role) {
  switch (role) {
    case WorkspaceItemRole.input:
      return Icons.inbox_outlined;
    case WorkspaceItemRole.aiResponse:
      return Icons.smart_toy_outlined;
    case WorkspaceItemRole.finalized:
      return Icons.verified_outlined;
    case WorkspaceItemRole.template:
      return Icons.dashboard_customize_outlined;
  }
}

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role});

  final WorkspaceItemRole role;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(roleIcon(role), size: 14, color: scheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            roleLabel(role),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.onSecondaryContainer,
                ),
          ),
        ],
      ),
    );
  }
}
