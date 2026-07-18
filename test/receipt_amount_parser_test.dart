import 'package:financely/features/transactions/domain/services/receipt_amount_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseReceiptTotal', () {
    test('reads a simple total with currency symbol', () {
      expect(parseReceiptTotal('Total: \$12.34'), 12.34);
    });

    test('handles European grouping (1.234,56)', () {
      expect(parseReceiptTotal('TOTAL  1.234,56'), 1234.56);
    });

    test('prefers total over subtotal', () {
      const receipt = '''
Coffee 4.00
Cake 6.00
Subtotal 10.00
Tax 2.34
Total 12.34
''';
      expect(parseReceiptTotal(receipt), 12.34);
    });

    test('falls back to largest decimal amount when no keyword', () {
      const receipt = '''
Item A 9.99
Item B 19.95
Item C 4.50
''';
      expect(parseReceiptTotal(receipt), 19.95);
    });

    test('picks the largest number on the total line', () {
      expect(parseReceiptTotal('Total 3 items 45.60'), 45.60);
    });

    test('returns null when there is no number', () {
      expect(parseReceiptTotal('Thank you for shopping'), isNull);
    });

    test('returns null for empty text', () {
      expect(parseReceiptTotal('   '), isNull);
    });
  });
}
