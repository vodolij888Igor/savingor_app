import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/startup_flow_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  /// Selected locale code before Continue.
  late String _selectedCode;
  bool _initialSelectionSynced = false;

  @override
  void initState() {
    super.initState();
    _selectedCode = 'en';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialSelectionSynced) return;
    _initialSelectionSynced = true;
    final saved = AppStateProvider.of(context).language;
    if (saved != null) {
      _selectedCode = StartupFlowStrings.normalizeLanguageCode(saved);
    } else {
      final sys = WidgetsBinding.instance.platformDispatcher.locale.languageCode
          .toLowerCase();
      if (StartupFlowStrings.supportedLanguageCodes.contains(sys)) {
        _selectedCode = sys;
      }
    }
  }

  String _pickerUiLang() {
    final sys = WidgetsBinding.instance.platformDispatcher.locale.languageCode
        .toLowerCase();
    if (StartupFlowStrings.supportedLanguageCodes.contains(sys)) {
      return sys;
    }
    return 'en';
  }

  _LangChoice _choiceFor(String code) {
    return _choices.firstWhere(
      (c) => c.code == code,
      orElse: () => _choices.first,
    );
  }

  void _continue() {
    final app = AppStateProvider.of(context);
    final hadLanguageAlready = app.language != null;
    app.setLanguage(_selectedCode);
    if (hadLanguageAlready) {
      context.go('/deals');
    } else {
      context.go('/splash');
    }
  }

  Future<void> _openLanguagePicker() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: SavingorColors.card,
                borderRadius: BorderRadius.circular(SavingorRadius.xl),
                border: Border.all(color: SavingorColors.border),
                boxShadow: SavingorShadows.medium,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: SavingorColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SavingorSpacing.lg,
                      vertical: SavingorSpacing.sm,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        StartupFlowStrings.tPicker(_pickerUiLang(), 'lang_title'),
                        style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: SavingorColors.darkGreen,
                            ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.52,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _choices.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: SavingorColors.border.withOpacity(0.65),
                      ),
                      itemBuilder: (listContext, i) {
                        final c = _choices[i];
                        final selected = c.code == _selectedCode;
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(sheetContext).pop(c.code),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SavingorSpacing.lg,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.primaryLabel,
                                          style: Theme.of(listContext)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: SavingorColors.textPrimary,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c.secondaryLabel,
                                          style: Theme.of(listContext)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: SavingorColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: SavingorColors.primaryGreen,
                                      size: 22,
                                    )
                                  else
                                    const Icon(
                                      Icons.circle_outlined,
                                      color: SavingorColors.border,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedCode = picked);
    }
  }

  static const List<_LangChoice> _choices = [
    _LangChoice('en', 'English', 'English'),
    _LangChoice('uk', 'Українська', 'Ukrainian'),
    _LangChoice('ru', 'Русский', 'Russian'),
    _LangChoice('fr', 'Français', 'French'),
    _LangChoice('de', 'Deutsch', 'German'),
    _LangChoice('es', 'Español', 'Spanish'),
  ];

  @override
  Widget build(BuildContext context) {
    final ui = _pickerUiLang();
    final current = _choiceFor(_selectedCode);

    return Scaffold(
      backgroundColor: SavingorColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          StartupFlowStrings.tPicker(ui, 'lang_title'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: SavingorColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: SavingorSpacing.sm),
                        Text(
                          StartupFlowStrings.tPicker(ui, 'lang_subtitle'),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: SavingorColors.textSecondary,
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: SavingorSpacing.section),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(SavingorRadius.xl),
                            onTap: _openLanguagePicker,
                            child: Ink(
                              decoration: BoxDecoration(
                                color: SavingorColors.card,
                                borderRadius:
                                    BorderRadius.circular(SavingorRadius.xl),
                                border: Border.all(
                                  color: SavingorColors.primaryStroke
                                      .withOpacity(0.4),
                                  width: 1,
                                ),
                                boxShadow: SavingorShadows.soft,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SavingorSpacing.lg,
                                  vertical: 18,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            current.primaryLabel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: SavingorColors.textPrimary,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            current.secondaryLabel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: SavingorColors
                                                      .textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: SavingorColors.darkGreen,
                                      size: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: FilledButton(
                    style: SavingorButtonStyles.primaryFilled(),
                    onPressed: _continue,
                    child: Text(
                      StartupFlowStrings.tPicker(ui, 'lang_continue'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangChoice {
  const _LangChoice(this.code, this.primaryLabel, this.secondaryLabel);

  final String code;
  final String primaryLabel;
  final String secondaryLabel;
}
