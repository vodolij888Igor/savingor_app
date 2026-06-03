/// Errors from the AI savings assistant service layer.
class AiAssistantException implements Exception {
  const AiAssistantException(this.message, {this.code});

  final String message;
  final String? code;

  static const AiAssistantException missingApiKey = AiAssistantException(
    'OpenAI API key is not configured. '
    'Run the app with --dart-define=OPENAI_API_KEY=your_key',
    code: 'missing_api_key',
  );

  @override
  String toString() => message;
}
