import 'package:cross_file/cross_file.dart';

import 'ocr_service_unsupported.dart'
    if (dart.library.io) 'ocr_service_mlkit.dart';

/// Text extraction from images.
///
/// Takes [XFile] (not dart:io File) so the same interface compiles on web,
/// where no file system exists. The Phase 1 implementation is on-device
/// Google ML Kit (mobile only); web receives a stub that reports the
/// feature as unavailable.
abstract class OcrService {
  Future<String> extractText(XFile imageFile);
}

class OcrUnsupportedException implements Exception {
  final String message;
  OcrUnsupportedException(this.message);
  @override
  String toString() => message;
}

/// Returns the platform-appropriate implementation.
OcrService createOcrService() => createPlatformOcrService();
