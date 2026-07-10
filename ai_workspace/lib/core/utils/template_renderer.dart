/// Renders an OutputProfile template.
///
/// Supported placeholders: `{{title}}`, `{{content}}`, `{{rawContent}}`.
/// Unknown placeholders are left untouched so future keys degrade gracefully.
String renderTemplate(
  String template, {
  String title = '',
  String content = '',
  String rawContent = '',
}) {
  return template
      .replaceAll('{{title}}', title)
      .replaceAll('{{content}}', content)
      .replaceAll('{{rawContent}}', rawContent);
}
