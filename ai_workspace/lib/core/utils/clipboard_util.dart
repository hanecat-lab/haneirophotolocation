import 'package:flutter/services.dart';

/// Clipboard utility (works on mobile and web).
class ClipboardUtil {
  ClipboardUtil._();

  static Future<void> copyText(String text) =>
      Clipboard.setData(ClipboardData(text: text));
}
