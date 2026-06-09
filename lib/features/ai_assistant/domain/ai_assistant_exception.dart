/// Errors from the AI savings assistant service layer.
class AiAssistantException implements Exception {
  const AiAssistantException(this.message, {this.code});

  final String message;
  final String? code;

  static const AiAssistantException missingApiKey = AiAssistantException(
    'AI assistant is ready. Connect an API key to enable live answers.',
    code: 'missing_api_key',
  );

  @override
  String toString() => message;
}
