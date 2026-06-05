import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/core/widgets/app_screen_states.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_parser.dart';
import 'package:savingor_app/features/scanner/data/receipt_ocr_service.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_source.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_source_badge.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  static const Color _pageBackground = Colors.white;

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
    letterSpacing: 0.2,
    height: 1.15,
  );

  final ImagePicker _imagePicker = ImagePicker();
  final ReceiptOcrService _ocrService = ReceiptOcrService();
  final ReceiptOcrParser _ocrParser = ReceiptOcrParser();

  bool _isScanning = false;

  void _openCreateReceipt() {
    context.push('/scanner/create');
  }

  Future<void> _onScanReceiptPressed() async {
    if (_isScanning) return;

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: SavingorColors.primaryStroke,
                ),
                title: const Text(
                  'Take photo',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: SavingorColors.primaryStroke,
                ),
                title: const Text(
                  'Choose from gallery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () =>
                    Navigator.of(sheetContext).pop(ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

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
        const SnackBar(content: Text('Scanning receipt...')),
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
        const SnackBar(
          content: Text('Could not scan this receipt. Try another photo.'),
        ),
      );
    }
  }

  Future<void> _showOcrPreviewDialog(
    String text,
    ReceiptSource receiptSource,
  ) async {
    if (text.trim().isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('OCR Result Preview'),
            content: const Text(
              'No text detected. Try a clearer receipt photo.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    }

    final ParsedReceiptData parsed = _ocrParser.parse(text);

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('OCR Result Preview'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildParsedField(
                    'Store',
                    parsed.storeName ?? '—',
                  ),
                  _buildParsedField(
                    'Date',
                    parsed.date != null
                        ? _formatParsedDate(parsed.date!)
                        : '—',
                  ),
                  _buildParsedField(
                    'Total',
                    parsed.total != null
                        ? '\$${parsed.total!.toStringAsFixed(2)}'
                        : '—',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Items:',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: SavingorColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (parsed.items.isEmpty)
                    const Text(
                      'None detected',
                      style: TextStyle(color: SavingorColors.textSecondary),
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
                      title: const Text(
                        'Raw OCR text',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: SavingorColors.darkGreen,
                        ),
                      ),
                      children: <Widget>[
                        SelectableText(
                          parsed.rawText,
                          style: const TextStyle(
                            fontSize: 12,
                            color: SavingorColors.textSecondary,
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
              child: const Text('Close'),
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
              child: const Text(
                'Use this receipt',
                style: TextStyle(fontWeight: FontWeight.w700),
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
          style: const TextStyle(
            fontSize: 14,
            color: SavingorColors.textSecondary,
            height: 1.35,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: SavingorColors.darkGreen,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: SavingorColors.darkGreen,
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

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? child) {
        if (!store.isAuthenticated) {
          return _buildSignInRequired(context);
        }

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text('Receipts', style: _titleStyle),
            centerTitle: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: _buildBody(context, store, bottomInset),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReceiptStore store,
    double bottomInset,
  ) {
    if (store.isLoading) {
      return const AppLoadingState(message: 'Loading receipts...');
    }

    if (store.loadError != null) {
      return AppErrorState(
        title: 'Could not load receipts',
        message: store.loadError!,
        onRetry: store.retry,
      );
    }

    if (store.receipts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _buildReceiptActions(),
          ),
          Expanded(
            child: AppEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No receipts yet',
              message:
                  'Add grocery receipts to track spending and unlock smarter savings insights.',
              actionLabel: 'Add receipt',
              prominentAction: true,
              onAction: _openCreateReceipt,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset + 72),
      itemCount: store.receipts.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return _buildReceiptActions();
        }

        final Receipt receipt = store.receipts[index - 1];
        return _ReceiptCard(
          receipt: receipt,
          onTap: () => context.push('/scanner/${receipt.id}'),
          onDelete: () => _confirmDelete(context, store, receipt),
        );
      },
    );
  }

  Widget _buildReceiptActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: _isScanning ? null : _onScanReceiptPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: SavingorColors.darkGreen,
            side: const BorderSide(color: SavingorColors.primaryStroke),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: _isScanning
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.document_scanner_outlined),
          label: Text(
            _isScanning ? 'Scanning...' : 'Scan receipt',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: _isScanning ? null : _openCreateReceipt,
          style: SavingorButtonStyles.primaryFilled(),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add manually',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInRequired(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        title: const Text('Receipts', style: _titleStyle),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: _pageBackground,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: AppSignInRequiredState(
        message:
            'Save and sync your receipts with your Savingor account.',
        onSignIn: () => context.push('/auth'),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ReceiptStore store,
    Receipt receipt,
  ) async {
    final String formattedTotal =
        '\$${receipt.total.toStringAsFixed(2)}';

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete receipt?'),
          content: Text(
            '${receipt.storeName} ($formattedTotal) will be permanently removed.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFB91C1C)),
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
        SnackBar(content: Text(error)),
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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: SavingorColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  color: SavingorColors.primaryStroke,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      receipt.storeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(receipt.date),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: SavingorColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      receipt.formattedTotal,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: SavingorColors.darkGreen,
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
                            '${receipt.itemCount} items',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: SavingorColors.textSecondary,
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
                color: SavingorColors.textSecondary,
                onPressed: onDelete,
              ),
            ],
          ),
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
