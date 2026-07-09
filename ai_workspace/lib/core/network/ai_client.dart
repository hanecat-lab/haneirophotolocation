/// Plugin architecture for AI providers.
///
/// Concrete implementations (OpenRouter, Groq, ...) are registered in Phase 2.
/// Application code must never branch on a provider name; it only talks to
/// this interface and to output profiles.
abstract class AiClient {
  String get providerId; // e.g., 'openrouter', 'groq'
  String get providerName; // e.g., 'OpenRouter', 'Groq'
  String get authUrl; // Official URL to get the API key

  /// Validates the API key via a lightweight request.
  /// Throws [AiProviderException] on failure.
  Future<bool> testConnection(String apiKey);

  /// Generates text completion.
  Future<String> generateText({
    required String apiKey,
    required String prompt,
    required String content,
    String? model,
  });
}

class AiProviderException implements Exception {
  final String message;
  final String? code;
  AiProviderException(this.message, {this.code});
  @override
  String toString() => message;
}
