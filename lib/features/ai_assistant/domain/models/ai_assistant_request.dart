import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';

/// User question plus compact financial context for the assistant.
class AiAssistantRequest {
  const AiAssistantRequest({
    required this.question,
    required this.context,
    this.responseLanguageCode = 'en',
  });

  final String question;
  final AiSavingsContext context;

  /// BCP-47 language code from the active Savingor app locale (e.g. `uk`, `en`).
  final String responseLanguageCode;
}
