import 'package:isar_community/isar.dart';

part 'output_profile.g.dart';

/// Output format specification.
///
/// The app depends on output profiles (Markdown, JSON, ...), never on
/// individual AI provider names. Copy/export/AI-prompting all go through a
/// profile's [templateText].
@collection
class OutputProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String profileId; // e.g., 'markdown_spec', 'json_summary', 'sns_post'
  late String name; // e.g., 'Standard Spec', 'JSON Summary', 'SNS Post'

  // Template body (e.g., "### Content\n{{content}}\n### Rules...")
  late String templateText;

  // Format type ('text', 'markdown', 'json', 'yaml')
  late String formatType;

  DateTime updatedAt = DateTime.now();
}
