import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:savingor_app/core/i18n/receipt_l10n.dart';
import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/savingor_interactive.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_service.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_source_badge.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_source_dialog.dart';
import 'package:savingor_app/l10n/app_localizations.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final ReceiptOcrService _ocrService = ReceiptOcrService();
  final ReceiptOcrParser _ocrParser = ReceiptOcrParser();

  bool _isScanning = false;
  bool _historyExpanded = false;

  void _openCreateReceipt() {
    context.push('/scanner/create');
  }

  Future<void> _onScanReceiptPressed() async {
    if (_isScanning) return;

    final ImageSource? source = await ReceiptSourceDialog.show(context);

    if (source == null || !mounted) return;

    await _pickAndScan(source);
  }

  Future<void> _pickAndScan(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null || !mounted) return;

      setState(() => _isScanning = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).scanningReceipt)),
      );

      final String text =
          await _ocrService.extractTextFromImagePath(image.path);

      if (!mounted) return;
      setState(() => _isScanning = false);

      await _showOcrPreviewDialog(
        text,
        source == ImageSource.camera
            ? ReceiptSource.scanned
            : ReceiptSource.gallery,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).couldNotScanReceipt),
        ),
      );
    }
  }

  Future<void> _showOcrPreviewDialog(
    String text,
    ReceiptSource receiptSource,
  ) async {
    if (text.trim().isEmpty) {
      final AppLocalizations l10n = AppLocalizations.of(context);
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(l10n.ocrResultPreview),
            content: Text(l10n.noTextDetected),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.close),
              ),
            ],
          );
        },
      );
      return;
    }

    final ParsedReceiptData parsed = _ocrParser.parse(text);
    final AppLocalizations l10n = AppLocalizations.of(context);

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.ocrResultPreview),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildParsedField(
                    l10n.store,
                    parsed.storeName ?? '—',
                  ),
                  _buildParsedField(
                    l10n.date,
                    parsed.date != null ? _formatParsedDate(parsed.date!) : '—',
                  ),
                  _buildParsedField(
                    l10n.total,
                    parsed.total != null
                        ? '\$${parsed.total!.toStringAsFixed(2)}'
                        : '—',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.itemsColon,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.savingor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (parsed.items.isEmpty)
                    Text(
                      l10n.noneDetected,
                      style: TextStyle(color: context.savingor.textSecondary),
                    )
                  else
                    ...parsed.items.map(
                      (String item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $item'),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(dialogContext).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        l10n.rawOcrText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.savingor.textPrimary,
                        ),
                      ),
                      children: <Widget>[
                        SelectableText(
                          parsed.rawText,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.savingor.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.close),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                context.push(
                  '/scanner/create',
                  extra: <String, dynamic>{
                    'initialStoreName': parsed.storeName,
                    'initialDate': parsed.date,
                    'initialTotal': parsed.total,
                    'initialCategory': 'Grocery',
                    'initialNotes': parsed.rawText,
                    'initialItemNames': parsed.items,
                    'initialSource': receiptSource.value,
                  },
                );
              },
              child: Text(
                l10n.useThisReceipt,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParsedField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: context.savingor.textSecondary,
            height: 1.35,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: context.savingor.textPrimary,
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: context.savingor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatParsedDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final ReceiptStore store = ReceiptProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;
    final AppLocalizations l10n = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return _buildSignInRequired(context, l10n);
        }

        return Scaffold(
          backgroundColor: context.savingor.pageBackground,
          appBar: AppBar(
            title: Text(l10n.receipts,
                style: SavingorAppTextStyles.screenTitle(context)),
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: context.savingor.pageBackground,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(context, store, bottomInset, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReceiptStore store,
    double bottomInset,
    AppLocalizations l10n,
  ) {
    if (store.isLoading) {
      return AppLoadingState(message: l10n.loadingReceipts);
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: l10n.couldNotLoadReceipts,
        message: ReceiptL10n.localizeError(context, store.loadError),
        onRetry: store.retry,
        actionLabel: l10n.tryAgain,
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset + 72),
      children: <Widget>[
        _buildScannerHero(l10n),
        const SizedBox(height: SavingorSpacing.md),
        _buildAddManuallyButton(l10n),
        const SizedBox(height: SavingorSpacing.xl),
        _buildReceiptHistorySection(context, store, l10n),
      ],
    );
  }

  Widget _buildScannerHero(AppLocalizations l10n) {
    final SavingorThemeExtension theme = context.savingor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: SavingorSurfaces.tabHeroCard(
        context,
        radius: 22,
        lightGradientColors: const <Color>[
          Color(0xFFF2FAF4),
          Color(0xFFFAFAF5),
          Color(0xFFF7FCF8),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.isDark
                  ? theme.surfaceElevated
                  : context.savingor.surfacePrimary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.isDark
                    ? theme.border.withOpacity(0.85)
                    : SavingorColors.primaryStroke.withOpacity(0.2),
              ),
              boxShadow: theme.isDark
                  ? null
                  : <BoxShadow>[
                      BoxShadow(
                        color: SavingorColors.primaryStroke.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              Icons.document_scanner_rounded,
              color: theme.brandTitle,
              size: 28,
            ),
          ),
          const SizedBox(height: SavingorSpacing.lg),
          Text(
            l10n.scanReceipt,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: context.savingor.textPrimary,
              height: 1.15,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.scanReceiptSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.savingor.textSecondary.withOpacity(0.95),
              height: 1.45,
            ),
          ),
          const SizedBox(height: SavingorSpacing.xl),
          SavingorInteractiveFilledButton(
            onPressed: _isScanning ? null : _onScanReceiptPressed,
            width: double.infinity,
            minHeight: 54,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            borderRadius: BorderRadius.circular(18),
            child: _isScanning
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.buttonLabelOnGreen,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.camera_alt_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l10n.scanReceipt),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddManuallyButton(AppLocalizations l10n) {
    final SavingorThemeExtension theme = context.savingor;
    final bool isDark = theme.isDark;

    return OutlinedButton.icon(
      onPressed: _isScanning ? null : _openCreateReceipt,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? theme.textPrimary : theme.brandHeading,
        backgroundColor: isDark ? theme.surfaceElevated : theme.surfacePrimary,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(
          color: theme.border.withOpacity(isDark ? 0.9 : 1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      icon: Icon(
        Icons.edit_note_outlined,
        size: 20,
        color: isDark ? theme.textPrimary : null,
      ),
      label: Text(l10n.addManually),
    );
  }

  Widget _buildReceiptHistorySection(
    BuildContext context,
    ReceiptStore store,
    AppLocalizations l10n,
  ) {
    final int count = store.receipts.length;

    return Container(
      width: double.infinity,
      decoration: SavingorSurfaces.premiumCard(context, radius: 18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _historyExpanded = !_historyExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 20,
                      color: context.savingor.brandTitle,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.recentReceipts(count),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.savingor.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _historyExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: context.savingor.textSecondary.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: context.savingor.border.withOpacity(0.55),
                ),
                if (count == 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                    child: Text(
                      l10n.noReceiptsYet,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: context.savingor.textSecondary.withOpacity(0.95),
                        height: 1.4,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                    child: Column(
                      children: <Widget>[
                        for (int i = 0;
                            i < store.receipts.length;
                            i++) ...<Widget>[
                          if (i > 0) const SizedBox(height: 10),
                          _ReceiptCard(
                            receipt: store.receipts[i],
                            onTap: () => context
                                .push('/scanner/${store.receipts[i].id}'),
                            onDelete: () => _confirmDelete(
                              context,
                              store,
                              store.receipts[i],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
            crossFadeState: _historyExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInRequired(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: context.savingor.pageBackground,
      appBar: AppBar(
        title: Text(l10n.receipts,
            style: SavingorAppTextStyles.screenTitle(context)),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: context.savingor.pageBackground,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: AppSignInRequiredState(
        title: l10n.signInRequired,
        message: l10n.signInToSyncReceipts,
        onSignIn: () => context.push('/auth'),
        actionLabel: l10n.signIn,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ReceiptStore store,
    Receipt receipt,
  ) async {
    final String formattedTotal = '\$${receipt.total.toStringAsFixed(2)}';

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        final AppLocalizations l10n = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(l10n.deleteReceiptQuestion),
          content: Text(
            l10n.deleteReceiptConfirmMessage(receipt.storeName, formattedTotal),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                l10n.delete,
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    await store.deleteReceipt(receipt.id);

    if (!context.mounted) return;

    final String? error = store.mutationError;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ReceiptL10n.localizeError(context, error))),
      );
    }
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({
    required this.receipt,
    required this.onTap,
    required this.onDelete,
  });

  final Receipt receipt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final SavingorThemeExtension theme = context.savingor;

    return SavingorInteractiveCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      accentTint:
          theme.isDark ? theme.accentGreen : SavingorColors.primaryStroke,
      borderColor: theme.isDark ? theme.border.withOpacity(0.85) : null,
      backgroundColor: theme.isDark ? theme.surfaceElevated : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
        child: Row(
          children: <Widget>[
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: theme.isDark
                    ? theme.surfaceStrong
                    : theme.selectedHighlight,
                borderRadius: BorderRadius.circular(14),
                border: theme.isDark
                    ? Border.all(color: theme.border.withOpacity(0.75))
                    : null,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: theme.brandTitle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receipt.storeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(receipt.date),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.textSecondary.withOpacity(0.96),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    receipt.formattedTotal,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: theme.brandTitle,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      ReceiptSourceBadge(
                        source: receipt.source,
                        compact: true,
                      ),
                      if (receipt.hasItems) ...<Widget>[
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)
                              .receiptItemsCount(receipt.itemCount),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.textSecondary.withOpacity(0.94),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              color: theme.textSecondary.withOpacity(0.92),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
