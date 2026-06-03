import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';

/// User question plus compact financial context for the assistant.
class AiAssistantRequest {
  const AiAssistantRequest({
    required this.question,
    required this.context,
  });

  final String question;
  final AiSavingsContext context;
}
