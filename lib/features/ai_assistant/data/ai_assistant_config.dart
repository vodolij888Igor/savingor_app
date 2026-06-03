/// Runtime AI configuration via `--dart-define` (no secrets in source).
abstract final class AiAssistantConfig {
  static const String openAiApiKey =
      String.fromEnvironment('OPENAI_API_KEY');

  static const String openAiApiBase = String.fromEnvironment(
    'OPENAI_API_BASE',
    defaultValue: 'https://api.openai.com/v1',
  );

  static const String openAiModel = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4o-mini',
  );

  static bool get hasOpenAiApiKey => openAiApiKey.isNotEmpty;

  static String get missingApiKeyMessage =>
      'OpenAI API key is not configured. '
      'Run the app with --dart-define=OPENAI_API_KEY=your_key';
}
