/// Extracts the most likely "total" amount from OCR-recognised receipt text.
///
/// Strategy:
///   1. Look at lines mentioning a total keyword (but not "subtotal"); take the
///      largest number on those lines.
///   2. Otherwise fall back to the largest money-looking number in the text.
///   3. Return null when nothing usable is found.
double? parseReceiptTotal(String text) {
  if (text.trim().isEmpty) return null;

  const totalKeywords = [
    'grand total',
    'amount due',
    'balance due',
    'total due',
    'total',
  ];

  final lines = text.split(RegExp(r'[\r\n]+'));
  double? keywordBest;

  for (final line in lines) {
    final lower = line.toLowerCase();
    final hasSubtotal = lower.contains('subtotal') || lower.contains('sub total');
    final hasTotal = totalKeywords.any(lower.contains);
    if (!hasTotal || hasSubtotal) continue;

    for (final amount in _amountsIn(line)) {
      if (keywordBest == null || amount > keywordBest) keywordBest = amount;
    }
  }
  if (keywordBest != null) return keywordBest;

  // Fallback: largest amount anywhere that has an explicit fractional part.
  double? fallback;
  for (final line in lines) {
    for (final amount in _amountsIn(line, requireDecimals: true)) {
      if (fallback == null || amount > fallback) fallback = amount;
    }
  }
  return fallback;
}

/// Finds monetary numbers in a single line. When [requireDecimals] is true only
/// tokens with a fractional part (e.g. `12.34`) are considered.
Iterable<double> _amountsIn(String line, {bool requireDecimals = false}) sync* {
  final pattern = RegExp(r'\d[\d.,]*\d|\d');
  for (final match in pattern.allMatches(line)) {
    final value = _normalizeAmount(match.group(0)!);
    if (value == null) continue;
    if (requireDecimals && value == value.roundToDouble()) continue;
    yield value;
  }
}

/// Normalises a raw numeric token into a double, coping with both `1,234.56`
/// and `1.234,56` grouping conventions. The rightmost `.`/`,` is treated as the
/// decimal separator; the other is stripped as a thousands grouper.
double? _normalizeAmount(String raw) {
  var token = raw.replaceAll(RegExp(r'[^0-9.,]'), '');
  if (token.isEmpty) return null;

  final lastDot = token.lastIndexOf('.');
  final lastComma = token.lastIndexOf(',');

  if (lastDot != -1 && lastComma != -1) {
    if (lastDot > lastComma) {
      token = token.replaceAll(',', ''); // comma = grouping
    } else {
      token = token.replaceAll('.', '').replaceAll(',', '.'); // comma = decimal
    }
  } else if (lastComma != -1) {
    final decimals = token.length - lastComma - 1;
    // A single comma with 1–2 trailing digits reads as a decimal separator;
    // anything else (e.g. 1,000) is thousands grouping.
    final singleComma = token.indexOf(',') == lastComma;
    token = (singleComma && decimals >= 1 && decimals <= 2)
        ? token.replaceAll(',', '.')
        : token.replaceAll(',', '');
  }

  return double.tryParse(token);
}
