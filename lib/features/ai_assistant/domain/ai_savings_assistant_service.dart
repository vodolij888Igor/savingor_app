import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_request.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_response.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/savings_insight.dart';

/// Contract for the savings assistant provider layer.
///
/// UI depends on this interface only. Swap implementations in [main.dart]
/// when moving calls to a FastAPI backend.
abstract class AiSavingsAssistantService {
  /// Whether remote AI credentials are available for this build.
  bool get isConfigured;

  /// Optional quick insight cards (local or AI-generated summary).
  Future<List<SavingsInsight>> generateInsights(AiSavingsContext context);

  /// Ask a natural-language question against compact user context.
  Future<AiAssistantResponse> ask(AiAssistantRequest request);
}
