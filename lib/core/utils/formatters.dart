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

  static String monthShort(DateTime date) => DateFormat.MMM().format(date);

  static String dayMonth(DateTime date) => DateFormat.MMMd().format(date);

  static String fullDate(DateTime date) => DateFormat.yMMMMd().format(date);

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat.EEEE().format(date);
    return DateFormat.MMMd().format(date);
  }
}
