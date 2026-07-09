import 'package:financely/features/currency/domain/usecases/change_currency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('currencyFactor', () {
    // USD-based table: units of each currency per 1 USD.
    const rates = {'idr': 16000.0, 'eur': 0.9, 'usd': 1.0};

    test('identity is 1', () {
      expect(currencyFactor(rates, 'USD', 'USD'), 1);
      expect(currencyFactor(rates, 'IDR', 'IDR'), 1);
    });

    test('USD to IDR uses the USD rate directly', () {
      expect(currencyFactor(rates, 'USD', 'IDR'), 16000);
    });

    test('IDR to USD is the inverse', () {
      expect(currencyFactor(rates, 'IDR', 'USD'), closeTo(1 / 16000, 1e-12));
    });

    test('cross rate EUR to IDR divides through USD', () {
      expect(currencyFactor(rates, 'EUR', 'IDR'), closeTo(16000 / 0.9, 1e-6));
    });

    test('is case-insensitive', () {
      expect(currencyFactor(rates, 'usd', 'idr'), 16000);
    });

    test('throws when a currency is missing from the table', () {
      expect(() => currencyFactor(rates, 'USD', 'GBP'), throwsException);
    });
  });
}
