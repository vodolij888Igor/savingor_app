import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Extracts raw text from receipt images using on-device ML Kit OCR.
class ReceiptOcrService {
  Future<String> extractTextFromImagePath(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final TextRecognizer recognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    try {
      final RecognizedText recognizedText =
          await recognizer.processImage(inputImage);
      return recognizedText.text.trim();
    } finally {
      await recognizer.close();
    }
  }
}
