import 'receipt_scanner.dart';

/// Web/desktop fallback: OCR is unsupported, so scanning is a no-op.
ReceiptScanner createReceiptScannerImpl() => const _UnsupportedReceiptScanner();

class _UnsupportedReceiptScanner implements ReceiptScanner {
  const _UnsupportedReceiptScanner();

  @override
  bool get isSupported => false;

  @override
  Future<double?> scanAmount(ScanSource source) async => null;
}
