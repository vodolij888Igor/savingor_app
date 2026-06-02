import 'package:flutter/widgets.dart';

import 'package:savingor_app/features/ai_assistant/data/local_ai_savings_assistant_service.dart';
import 'package:savingor_app/features/ai_assistant/domain/ai_savings_assistant_service.dart';

/// Supplies [AiSavingsAssistantService] to the widget tree.
///
/// Swap [service] in [main.dart] for a remote backend implementation later.
class AiSavingsAssistantProvider extends InheritedWidget {
  const AiSavingsAssistantProvider({
    super.key,
    required this.service,
    required super.child,
  });

  final AiSavingsAssistantService service;

  static AiSavingsAssistantService of(BuildContext context) {
    final AiSavingsAssistantProvider? provider =
        context.dependOnInheritedWidgetOfExactType<AiSavingsAssistantProvider>();
    if (provider == null) {
      throw FlutterError('AiSavingsAssistantProvider not found');
    }
    return provider.service;
  }

  @override
  bool updateShouldNotify(AiSavingsAssistantProvider oldWidget) {
    return service != oldWidget.service;
  }
}

/// Default service for production wiring until remote backend exists.
AiSavingsAssistantService createDefaultAiSavingsAssistantService() {
  return const LocalAiSavingsAssistantService();
}
