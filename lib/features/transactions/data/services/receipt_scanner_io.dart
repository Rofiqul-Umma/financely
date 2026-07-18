import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/services/receipt_amount_parser.dart';
import '../../domain/services/receipt_scanner.dart';

ReceiptScanner createReceiptScannerImpl() => MLKitReceiptScanner();

/// On-device receipt OCR using Google ML Kit text recognition. Supported on
/// Android and iOS only.
class MLKitReceiptScanner implements ReceiptScanner {
  final ImagePicker _picker;
  MLKitReceiptScanner({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<double?> scanAmount(ScanSource source) async {
    final image = await _picker.pickImage(
      source: source == ScanSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
    );
    if (image == null) return null;

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(image.path),
      );
      return parseReceiptTotal(result.text);
    } finally {
      await recognizer.close();
    }
  }
}
