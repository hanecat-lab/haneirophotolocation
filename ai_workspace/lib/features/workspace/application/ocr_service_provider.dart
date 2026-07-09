import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'ocr_service.dart';

part 'ocr_service_provider.g.dart';

@Riverpod(keepAlive: true)
OcrService ocrService(Ref ref) => createOcrService();
