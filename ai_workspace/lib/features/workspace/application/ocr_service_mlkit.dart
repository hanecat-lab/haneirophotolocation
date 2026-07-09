import 'package:cross_file/cross_file.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'ocr_service.dart';

OcrService createPlatformOcrService() => MlKitOcrService();

/// On-device OCR via Google ML Kit (Android/iOS). No API key, no network.
class MlKitOcrService implements OcrService {
  @override
  Future<String> extractText(XFile imageFile) async {
    final recognizer =
        TextRecognizer(script: TextRecognitionScript.japanese);
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final result = await recognizer.processImage(inputImage);
      return result.text;
    } finally {
      await recognizer.close();
    }
  }
}
