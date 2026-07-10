import 'package:ai_workspace/core/utils/template_renderer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('renderTemplate', () {
    test('replaces title and content placeholders', () {
      final result = renderTemplate(
        '## {{title}}\n\n{{content}}\n',
        title: '議事録',
        content: '本文テキスト',
      );
      expect(result, '## 議事録\n\n本文テキスト\n');
    });

    test('replaces rawContent placeholder', () {
      final result = renderTemplate(
        '{{rawContent}}',
        rawContent: 'OCR直後のテキスト',
      );
      expect(result, 'OCR直後のテキスト');
    });

    test('replaces repeated placeholders everywhere', () {
      final result = renderTemplate(
        '{{content}} / {{content}}',
        content: 'A',
      );
      expect(result, 'A / A');
    });

    test('leaves unknown placeholders untouched', () {
      final result = renderTemplate(
        '{{content}} {{unknownKey}}',
        content: 'A',
      );
      expect(result, 'A {{unknownKey}}');
    });

    test('missing values default to empty strings', () {
      expect(renderTemplate('[{{title}}]'), '[]');
    });
  });
}
