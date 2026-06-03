/// Natural-language answer from the savings assistant.
class AiAssistantResponse {
  const AiAssistantResponse({
    required this.answer,
    this.model,
  });

  final String answer;
  final String? model;
}
