import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/ai_assistant/domain/ai_assistant_exception.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

/// Display-time localization for the AI Savings Assistant feature.
abstract final class AiAssistantL10n {
  /// Maps app locale codes to English language names for LLM instructions.
  static String responseLanguageNameForCode(String languageCode) {
    return switch (languageCode) {
      'uk' => 'Ukrainian',
      'ru' => 'Russian',
      'fr' => 'French',
      'de' => 'German',
      'es' => 'Spanish',
      _ => 'English',
    };
  }

  static String localizeException(
    BuildContext context,
    AiAssistantException error,
  ) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return switch (error.code) {
      'missing_api_key' => l10n.aiConfigReadyMessage,
      'http_error' => l10n.aiRequestFailed,
      'empty_response' => l10n.aiEmptyResponse,
      _ => switch (error.message) {
          'AI assistant is ready. Connect an API key to enable live answers.' =>
            l10n.aiConfigReadyMessage,
          'AI returned an empty response.' => l10n.aiEmptyResponse,
          _ => error.message,
        },
    };
  }
}
