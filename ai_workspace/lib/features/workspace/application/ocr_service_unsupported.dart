import 'package:cross_file/cross_file.dart';

import 'ocr_service.dart';

OcrService createPlatformOcrService() => UnsupportedOcrService();

/// Web fallback: ML Kit is mobile-only. Images can still be stored and
/// managed on web; only automatic text extraction is unavailable.
class UnsupportedOcrService implements OcrService {
  @override
  Future<String> extractText(XFile imageFile) async {
    throw OcrUnsupportedException(
      'このプラットフォームではOCR（ML Kit）を利用できません。'
      '画像の保存は可能です。テキストは手動で入力してください。',
    );
  }
}
