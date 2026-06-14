import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:savingor_app/features/scanner/domain/models/receipt_ocr_result.dart';

/// Extracts raw text and line geometry from receipt images using on-device ML Kit OCR.
class ReceiptOcrService {
  /// Recognizes a receipt image and returns structured OCR output with geometry.
  Future<ReceiptOcrResult> recognizeFromImagePath(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final TextRecognizer recognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final RecognizedText recognizedText =
          await recognizer.processImage(inputImage);
      return _mapRecognizedText(recognizedText);
    } finally {
      await recognizer.close();
    }
  }

  /// Backward-compatible flat text extraction.
  Future<String> extractTextFromImagePath(String imagePath) async {
    final ReceiptOcrResult result = await recognizeFromImagePath(imagePath);
    return result.rawText;
  }

  ReceiptOcrResult _mapRecognizedText(RecognizedText recognizedText) {
    final List<ReceiptOcrLine> lines = <ReceiptOcrLine>[];
    bool hasGeometry = false;

    for (int blockIndex = 0;
        blockIndex < recognizedText.blocks.length;
        blockIndex++) {
      final TextBlock block = recognizedText.blocks[blockIndex];
      for (int lineIndex = 0; lineIndex < block.lines.length; lineIndex++) {
        final TextLine line = block.lines[lineIndex];
        final String text = line.text.trim();
        if (text.isEmpty) continue;

        final Rect box = line.boundingBox;
        hasGeometry = true;
        lines.add(
          ReceiptOcrLine(
            text: text,
            left: box.left,
            top: box.top,
            right: box.right,
            bottom: box.bottom,
            blockIndex: blockIndex,
            lineIndex: lineIndex,
          ),
        );
      }
    }

    return ReceiptOcrResult(
      rawText: recognizedText.text.trim(),
      lines: lines,
      hasGeometry: hasGeometry,
    );
  }
}
