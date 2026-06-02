import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/savings_insight.dart';

/// Contract for generating savings insights.
///
/// Today: [LocalAiSavingsAssistantService] derives insights from Firestore data.
/// Later: swap for a Firebase Callable / HTTPS backend that calls OpenAI securely
/// (API keys stay server-side only).
abstract class AiSavingsAssistantService {
  Future<List<SavingsInsight>> generateInsights(AiSavingsContext context);
}
