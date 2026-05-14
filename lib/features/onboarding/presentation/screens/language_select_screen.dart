import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/app_state.dart';
import 'package:savingor_app/core/i18n/startup_flow_strings.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen>
    with SingleTickerProviderStateMixin {
  static const String _backgroundAsset = 'assets/images/language_screen_bg.png';

  /// Inline dropdown expand/collapse timing — same for both directions so the
  /// SizeTransition (list height) and RotationTransition (arrow) stay in sync.
  static const Duration _dropdownDuration = Duration(milliseconds: 300);
  static const Curve _dropdownCurve = Curves.easeOutCubic;

  static const List<Shadow> _copyShadows = <Shadow>[
    Shadow(
      color: Color(0xE6FFFFFF),
      blurRadius: 14,
      offset: Offset(0, 1),
    ),
    Shadow(
      color: Color(0x22000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Selected locale code before Continue.
  late String _selectedCode;
  bool _initialSelectionSynced = false;

  /// Whether the inline dropdown is currently expanded.
  bool _isDropdownOpen = false;

  late final AnimationController _dropdownController;
  late final Animation<double> _dropdownAnim;

  @override
  void initState() {
    super.initState();
    _selectedCode = 'en';
    _dropdownController = AnimationController(
      vsync: this,
      duration: _dropdownDuration,
    );
    _dropdownAnim = CurvedAnimation(
      parent: _dropdownController,
      curve: _dropdownCurve,
      reverseCurve: _dropdownCurve,
    );
  }

  @override
  void dispose() {
    _dropdownController.dispose();
    super.dispose();
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

  /// UI language used to render the language screen's own title / subtitle /
  /// Continue label. Driven by [_selectedCode] so every dropdown tap triggers
  /// an immediate rebuild of the screen in the chosen language. The initial
  /// value of [_selectedCode] is seeded in [didChangeDependencies] from the
  /// saved app-state language (returning users) or the system locale when it
  /// is one of the supported codes, falling back to `'en'`.
  String _pickerUiLang() =>
      StartupFlowStrings.normalizeLanguageCode(_selectedCode);

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

  void _toggleDropdown() {
    setState(() => _isDropdownOpen = !_isDropdownOpen);
    if (_isDropdownOpen) {
      _dropdownController.forward();
    } else {
      _dropdownController.reverse();
    }
  }

  void _selectLanguage(String code) {
    setState(() {
      _selectedCode = code;
      _isDropdownOpen = false;
    });
    _dropdownController.reverse();
  }

  static const List<_LangChoice> _choices = <_LangChoice>[
    _LangChoice('en', 'English', 'English', 'assets/flags/gb.svg'),
    _LangChoice('uk', 'Українська', 'Ukrainian', 'assets/flags/ua.svg'),
    _LangChoice('ru', 'Русский', 'Russian', 'assets/flags/ru.svg'),
    _LangChoice('fr', 'Français', 'French', 'assets/flags/fr.svg'),
    _LangChoice('de', 'Deutsch', 'German', 'assets/flags/de.svg'),
    _LangChoice('es', 'Español', 'Spanish', 'assets/flags/es.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    final String ui = _pickerUiLang();
    final _LangChoice current = _choiceFor(_selectedCode);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              _backgroundAsset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double safeHeight = constraints.maxHeight;
                final double topInset = safeHeight * 0.26;
                // Cap the expanded list so the open dropdown never overflows
                // and the Continue button stays anchored to the bottom.
                // Tuned so the Spacer never collapses below ~20 px on common
                // phone safe areas; the list becomes scrollable if 6 rows
                // exceed the cap.
                final double listMaxHeight =
                    (safeHeight * 0.32).clamp(170.0, 330.0);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: topInset),
                      Text(
                        StartupFlowStrings.tPicker(ui, 'lang_title'),
                        textAlign: TextAlign.center,
                        style: SavingorTextStyles.onboardingTitle.copyWith(
                          shadows: _copyShadows,
                        ),
                      ),
                      const SizedBox(height: SavingorSpacing.sm),
                      Text(
                        StartupFlowStrings.tPicker(ui, 'lang_subtitle'),
                        textAlign: TextAlign.center,
                        style: SavingorTextStyles.onboardingSubtitle.copyWith(
                          shadows: _copyShadows,
                        ),
                      ),
                      const SizedBox(height: SavingorSpacing.xl),
                      _InlineLanguageDropdown(
                        current: current,
                        choices: _choices,
                        selectedCode: _selectedCode,
                        animation: _dropdownAnim,
                        listMaxHeight: listMaxHeight,
                        onToggle: _toggleDropdown,
                        onSelect: _selectLanguage,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineLanguageDropdown extends StatelessWidget {
  const _InlineLanguageDropdown({
    required this.current,
    required this.choices,
    required this.selectedCode,
    required this.animation,
    required this.listMaxHeight,
    required this.onToggle,
    required this.onSelect,
  });

  final _LangChoice current;
  final List<_LangChoice> choices;
  final String selectedCode;
  final Animation<double> animation;

  /// Hard cap for the expanded list area; the list scrolls inside this box
  /// if six rows do not fit, guaranteeing no bottom overflow.
  final double listMaxHeight;

  final VoidCallback onToggle;
  final ValueChanged<String> onSelect;

  static final BorderRadius _radius =
      BorderRadius.circular(SavingorRadius.xl);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: _radius,
        boxShadow: SavingorShadows.medium,
      ),
      child: ClipRRect(
        borderRadius: _radius,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SavingorSpacing.lg,
                    vertical: 14,
                  ),
                  child: Row(
                    children: <Widget>[
                      _FlagSlot(asset: current.flagAsset),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                                    color: SavingorColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      RotationTransition(
                        turns: Tween<double>(begin: 0, end: 0.5)
                            .animate(animation),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: SavingorColors.darkGreen,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: listMaxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: SavingorSpacing.lg,
                        endIndent: SavingorSpacing.lg,
                        color: SavingorColors.border.withOpacity(0.55),
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: choices.length,
                          itemBuilder: (BuildContext _, int i) {
                            return _DropdownRow(
                              choice: choices[i],
                              selected: choices[i].code == selectedCode,
                              showDivider: i < choices.length - 1,
                              onTap: () => onSelect(choices[i].code),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.choice,
    required this.selected,
    required this.showDivider,
    required this.onTap,
  });

  final _LangChoice choice;
  final bool selected;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
            color: selected
                ? SavingorColors.lightGreen.withOpacity(0.55)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: SavingorSpacing.lg,
              vertical: 10,
            ),
            child: Row(
              children: <Widget>[
                _FlagSlot(asset: choice.flagAsset),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        choice.primaryLabel,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: SavingorColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        choice.secondaryLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                  const SizedBox(width: 22, height: 22),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            indent: SavingorSpacing.lg,
            endIndent: SavingorSpacing.lg,
            color: SavingorColors.border.withOpacity(0.5),
          ),
      ],
    );
  }
}

class _FlagSlot extends StatelessWidget {
  const _FlagSlot({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Center(
        child: SvgPicture.asset(
          asset,
          width: 26,
          height: 26,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _LangChoice {
  const _LangChoice(
    this.code,
    this.primaryLabel,
    this.secondaryLabel,
    this.flagAsset,
  );

  final String code;
  final String primaryLabel;
  final String secondaryLabel;
  final String flagAsset;
}
