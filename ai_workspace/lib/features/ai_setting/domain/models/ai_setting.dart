import 'package:isar_community/isar.dart';

part 'ai_setting.g.dart';

/// User-managed API configuration (self-funded API keys).
///
/// The key itself is stored encrypted; encryption/decryption is handled by
/// the ai_setting data layer (Phase 2). The app must remain fully functional
/// when no key is configured (providerId == 'none').
@collection
class AiSetting {
  Id id = Isar.autoIncrement;

  // Selected provider ID ('none', 'openrouter', 'groq', 'gemini', 'openai', 'claude')
  @Index(unique: true, replace: true)
  String providerId = 'none';

  // Securely stored API key (encrypted in IndexedDB for Web / Secure Storage for Mobile)
  String encryptedApiKey = '';

  DateTime updatedAt = DateTime.now();
}
