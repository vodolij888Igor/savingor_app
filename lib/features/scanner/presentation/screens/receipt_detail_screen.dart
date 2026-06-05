import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:savingor_app/core/theme/savingor_design_system.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt.dart';
import 'package:savingor_app/features/receipts/domain/models/receipt_item.dart';
import 'package:savingor_app/features/receipts/presentation/widgets/receipt_source_badge.dart';
import 'package:savingor_app/features/scanner/data/receipt_store.dart';

class ReceiptDetailScreen extends StatelessWidget {
  const ReceiptDetailScreen({super.key, required this.receiptId});

  final String receiptId;

  static const Color _pageBackground = Colors.white;
  static const Color _airyBorder = Color(0xFFF3F4F3);

  static const TextStyle _appBarTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: SavingorColors.darkGreen,
  );

  static String _formatDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: _airyBorder.withOpacity(0.6), width: 0.5),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReceiptStore store = ReceiptProvider.of(context);
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, Widget? _) {
        final Receipt? receipt = store.receiptById(receiptId);

        return Scaffold(
          backgroundColor: _pageBackground,
          appBar: AppBar(
            title: const Text('Receipt details', style: _appBarTitleStyle),
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: _pageBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: SavingorColors.darkGreen,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          body: receipt == null
              ? const Center(
                  child: Text(
                    'Receipt not found.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary,
                    ),
                  ),
                )
              : _buildContent(context, store, receipt, bottomInset),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReceiptStore store,
    Receipt receipt,
    double bottomInset,
  ) {
    final String formattedDate = _formatDate(receipt.purchaseDate);
    final bool hasNotes =
        receipt.notes != null && receipt.notes!.trim().isNotEmpty;

    return ListView(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      receipt.storeName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: SavingorColors.darkGreen,
                      ),
                    ),
                  ),
                  ReceiptSourceBadge(source: receipt.source),
                ],
              ),
              if (receipt.hasAddress) ...<Widget>[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: SavingorColors.primaryStroke.withOpacity(0.85),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        receipt.displayAddress!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: SavingorColors.darkGreen.withOpacity(0.8),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: SavingorColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                receipt.category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: SavingorColors.primaryStroke,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                receipt.formattedTotal,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: SavingorColors.darkGreen,
                  letterSpacing: -0.5,
                ),
              ),
              if (receipt.subtotal != null || receipt.tax != null) ...<Widget>[
                const SizedBox(height: 8),
                if (receipt.subtotal != null)
                  Text(
                    'Subtotal: \$${receipt.subtotal!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary.withOpacity(0.95),
                    ),
                  ),
                if (receipt.tax != null)
                  Text(
                    'Tax: \$${receipt.tax!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SavingorColors.textSecondary.withOpacity(0.95),
                    ),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SavingorSpacing.lg),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Items',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: SavingorColors.darkGreen,
                ),
              ),
            ),
            Text(
              receipt.hasItems ? '${receipt.itemCount} items' : 'No items saved',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: SavingorColors.textSecondary.withOpacity(0.9),
              ),
            ),
          ],
        ),
        const SizedBox(height: SavingorSpacing.sm),
        if (receipt.hasItems)
          Container(
            decoration: _cardDecoration(),
            child: Column(
              children: List<Widget>.generate(receipt.items.length, (int index) {
                final ReceiptItem item = receipt.items[index];
                return Column(
                  children: <Widget>[
                    if (index > 0) _detailDivider(),
                    _itemRow(item),
                  ],
                );
              }),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Text(
              'No line items were saved for this receipt yet.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SavingorColors.textSecondary.withOpacity(0.95),
                height: 1.4,
              ),
            ),
          ),
        if (hasNotes) ...<Widget>[
          const SizedBox(height: SavingorSpacing.lg),
          Text(
            receipt.notesSectionTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: SavingorColors.darkGreen,
            ),
          ),
          const SizedBox(height: SavingorSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Text(
              receipt.notes!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: SavingorColors.darkGreen,
                height: 1.45,
              ),
            ),
          ),
        ],
        const SizedBox(height: SavingorSpacing.lg),
        OutlinedButton.icon(
          onPressed: () {
            context.push(
              '/scanner/create',
              extra: <String, dynamic>{
                'receiptId': receipt.id,
                'isEditing': true,
              },
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: SavingorColors.darkGreen,
            side: const BorderSide(color: SavingorColors.primaryStroke),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.edit_outlined),
          label: const Text(
            'Edit receipt',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: SavingorSpacing.md),
        OutlinedButton.icon(
          onPressed: () => _confirmDelete(context, store, receipt),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFB91C1C),
            side: const BorderSide(color: Color(0xFFE5A8A8)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.delete_outline_rounded),
          label: const Text(
            'Delete receipt',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _itemRow(ReceiptItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: SavingorColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty ${item.displayQuantity}'
                      '${item.category != null ? ' · ${item.category}' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: SavingorColors.textSecondary.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.formattedTotalPrice,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: SavingorColors.primaryStroke,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDivider() {
    return Divider(
      height: 1,
      color: _airyBorder.withOpacity(0.8),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ReceiptStore store,
    Receipt receipt,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete receipt?'),
          content: Text(
            '${receipt.storeName} (${receipt.formattedTotal}) will be permanently removed.',
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

    final bool deleted = await store.deleteReceipt(receipt.id);

    if (!context.mounted) return;

    if (deleted) {
      context.pop();
      return;
    }

    final String? error = store.mutationError;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Could not delete the receipt. Please try again.',
        ),
      ),
    );
  }
}
