import 'package:intl/intl.dart';

import '../constants/currencies.dart';

class Formatters {
  const Formatters._();

  static String currency(double amount, {String code = 'USD'}) {
    final symbol = currencyByCode(code).symbol;
    final digits = code == 'JPY' || code == 'IDR' ? 0 : 2;
    return NumberFormat.currency(symbol: symbol, decimalDigits: digits)
        .format(amount);
  }

  static String signedCurrency(double amount, {String code = 'USD'}) {
    final prefix = amount > 0 ? '+' : amount < 0 ? '-' : '';
    return '$prefix${currency(amount.abs(), code: code)}';
  }

  static String compactCurrency(double amount, {String code = 'USD'}) {
    final symbol = currencyByCode(code).symbol;
    return NumberFormat.compactCurrency(symbol: symbol, decimalDigits: 1)
        .format(amount);
  }

  static String monthShort(DateTime date, {String? locale}) =>
      DateFormat.MMM(locale).format(date);

  static String dayMonth(DateTime date, {String? locale}) =>
      DateFormat.MMMd(locale).format(date);

  static String fullDate(DateTime date, {String? locale}) =>
      DateFormat.yMMMMd(locale).format(date);
}
