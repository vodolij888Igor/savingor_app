import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:savingor_app/core/app_state.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String _selectedLanguage = 'uk';

  void _continue() {
    AppStateProvider.of(context).setLanguage(_selectedLanguage);
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SavingorColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Choose your language',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: SavingorSpacing.sm),
                        Text(
                          'This helps personalize your Savingor experience.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: SavingorColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: SavingorSpacing.section),
                        _LanguageOption(
                          title: 'Ukrainian',
                          subtitle: 'Українська',
                          selected: _selectedLanguage == 'uk',
                          onTap: () => setState(() => _selectedLanguage = 'uk'),
                        ),
                        const SizedBox(height: SavingorSpacing.md),
                        _LanguageOption(
                          title: 'English',
                          subtitle: 'English',
                          selected: _selectedLanguage == 'en',
                          onTap: () => setState(() => _selectedLanguage = 'en'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: FilledButton(
                    onPressed: _continue,
                    child: const Text('Continue'),
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(SavingorRadius.lg),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: selected ? SavingorColors.lightGreen : SavingorColors.card,
          borderRadius: BorderRadius.circular(SavingorRadius.lg),
          border: Border.all(
            color: selected ? SavingorColors.primaryGreen : SavingorColors.border,
            width: selected ? 1.6 : 1,
          ),
          boxShadow: SavingorShadows.soft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: SavingorColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SavingorColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  selected ? SavingorColors.primaryGreen : SavingorColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
