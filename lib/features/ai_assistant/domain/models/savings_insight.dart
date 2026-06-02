/// Category of savings guidance shown by the assistant.
enum InsightType {
  spending,
  shopping,
  savings,
  receipt,
  onboarding,
}

/// Visual priority for an insight card.
enum InsightSeverity {
  info,
  positive,
  warning,
}

/// A single AI-style savings recommendation derived from user data.
class SavingsInsight {
  const SavingsInsight({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.severity = InsightSeverity.info,
    this.highlightValue,
  });

  final String id;
  final String title;
  final String message;
  final InsightType type;
  final InsightSeverity severity;
  final String? highlightValue;
}
