import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/workspace/presentation/pages/inbox_page.dart';

class AiWorkspaceApp extends StatelessWidget {
  const AiWorkspaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Workspace',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const InboxPage(),
    );
  }
}
