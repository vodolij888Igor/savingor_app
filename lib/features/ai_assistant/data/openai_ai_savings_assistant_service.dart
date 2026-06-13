import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:savingor_app/core/i18n/ai_assistant_l10n.dart';
import 'package:savingor_app/features/ai_assistant/data/ai_assistant_config.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_assistant_exception.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_context.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_request.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/ai_assistant_response.dart';
import 'package:savingor_app/features/ai_assistant/domain/models/savings_insight.dart';

/// OpenAI-compatible chat client for development builds.
///
/// Later: replace with an HTTPS call to your FastAPI backend using the same
/// request/response models.
class OpenAiAiSavingsAssistantService implements AiSavingsAssistantService {
  OpenAiAiSavingsAssistantService({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  @override
  bool get isConfigured => AiAssistantConfig.hasOpenAiApiKey;

  @override
  Future<AiAssistantResponse> ask(AiAssistantRequest request) async {
    if (!isConfigured) {
      throw AiAssistantException.missingApiKey;
    }

    final String languageName = AiAssistantL10n.responseLanguageNameForCode(
      request.responseLanguageCode,
    );
    final String answer = await _completeChat(
      systemPrompt: _systemPrompt(languageName),
      userPrompt: _buildUserPrompt(request, languageName),
    );

    return AiAssistantResponse(
      answer: answer,
      model: AiAssistantConfig.openAiModel,
    );
  }

  @override
  Future<List<SavingsInsight>> generateInsights(
    AiSavingsContext context,
  ) async {
    if (!context.hasData) return const <SavingsInsight>[];

    final AiAssistantResponse response = await ask(
      AiAssistantRequest(
        question:
            'Give me 3 concise savings insights based on my current data.',
        context: context,
      ),
    );

    return <SavingsInsight>[
      SavingsInsight(
        id: 'ai-summary',
        title: 'AI savings summary',
        message: response.answer,
        type: InsightType.savings,
        severity: InsightSeverity.positive,
      ),
    ];
  }

  Future<String> _completeChat({
    required String systemPrompt,
    required String userPrompt,
  }) async {
    final Uri uri = Uri.parse(
      '${AiAssistantConfig.openAiApiBase}/chat/completions',
    );

    final http.Response response = await _httpClient.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AiAssistantConfig.openAiApiKey}',
      },
      body: jsonEncode(<String, dynamic>{
        'model': AiAssistantConfig.openAiModel,
        'temperature': 0.4,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'system', 'content': systemPrompt},
          <String, String>{'role': 'user', 'content': userPrompt},
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AiAssistantException(
        'AI request failed (${response.statusCode}). Please try again.',
        code: 'http_error',
      );
    }

    final Map<String, dynamic> decoded =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic>? choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const AiAssistantException(
        'AI returned an empty response.',
        code: 'empty_response',
      );
    }

    final Map<String, dynamic>? message =
        choices.first['message'] as Map<String, dynamic>?;
    final String? content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw const AiAssistantException(
        'AI returned an empty response.',
        code: 'empty_response',
      );
    }

    return content.trim();
  }

  static String _systemPrompt(String languageName) => '''
You are Savingor AI Savings Assistant, a helpful grocery budgeting coach.

Rules:
- Base answers ONLY on the structured user context provided.
- Mention when insights come from saved receipts, manual expenses, or shopping lists.
- Do NOT claim live store prices, real-time deals, or that a store is currently cheapest unless that data is explicitly in context.
- You may suggest comparing prices, using shopping lists, or reviewing recent spending patterns.
- Be practical, concise, and mobile-friendly (short paragraphs or bullets).
- If data is missing for part of a question, say what is missing and answer with what is available.
- Respond in $languageName. Use clear, practical language appropriate for the user's selected Savingor app language.
- Keep store names, brands, currency codes, and numeric values unchanged.
''';

  String _buildUserPrompt(AiAssistantRequest request, String languageName) {
    final String contextJson = const JsonEncoder.withIndent('  ')
        .convert(request.context.toPromptMap());

    return '''
User question:
${request.question.trim()}

Structured Savingor user context (JSON):
$contextJson

Respond in $languageName for a mobile app user.
''';
  }
}
