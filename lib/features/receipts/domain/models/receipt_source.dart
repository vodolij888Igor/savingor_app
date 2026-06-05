import 'package:flutter/material.dart';

/// How a receipt entered the Savingor system.
enum ReceiptSource {
  manual('manual', 'Manual'),
  scanned('scanned', 'Scanned'),
  gallery('gallery', 'Gallery'),
  imported('imported', 'Imported'),
  unknown('unknown', 'Receipt');

  const ReceiptSource(this.value, this.label);

  final String value;
  final String label;

  IconData get icon {
    switch (this) {
      case ReceiptSource.manual:
        return Icons.edit_outlined;
      case ReceiptSource.scanned:
        return Icons.document_scanner_outlined;
      case ReceiptSource.gallery:
        return Icons.photo_library_outlined;
      case ReceiptSource.imported:
        return Icons.upload_outlined;
      case ReceiptSource.unknown:
        return Icons.receipt_long_outlined;
    }
  }

  /// Section title for optional notes / raw OCR text on receipt details.
  String get notesSectionTitle {
    switch (this) {
      case ReceiptSource.scanned:
        return 'Scan notes';
      case ReceiptSource.gallery:
        return 'Gallery scan notes';
      case ReceiptSource.imported:
        return 'Import notes';
      case ReceiptSource.manual:
      case ReceiptSource.unknown:
        return 'Notes';
    }
  }

  bool get isFromImageCapture =>
      this == ReceiptSource.scanned || this == ReceiptSource.gallery;

  static ReceiptSource fromValue(String? value) {
    if (value == null || value.isEmpty) {
      return ReceiptSource.manual;
    }
    for (final ReceiptSource source in ReceiptSource.values) {
      if (source.value == value) {
        return source;
      }
    }
    return ReceiptSource.unknown;
  }
}
