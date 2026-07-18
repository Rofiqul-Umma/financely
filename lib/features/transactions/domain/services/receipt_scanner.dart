import 'receipt_scanner_stub.dart'
    if (dart.library.io) '../../data/services/receipt_scanner_io.dart';

/// Where the receipt image comes from.
enum ScanSource { camera, gallery }

/// Scans a receipt image and returns the detected total amount.
///
/// Backed by on-device OCR on Android/iOS; unsupported (a no-op) on web and
/// desktop, where [isSupported] is false.
abstract interface class ReceiptScanner {
  bool get isSupported;

  /// Picks an image from [source], runs OCR, and returns the parsed total, or
  /// null if the user cancelled or no amount could be read.
  Future<double?> scanAmount(ScanSource source);
}

/// Platform-appropriate [ReceiptScanner]: the ML Kit implementation on native
/// (dart:io) platforms, or an unsupported stub on the web.
ReceiptScanner createReceiptScanner() => createReceiptScannerImpl();
