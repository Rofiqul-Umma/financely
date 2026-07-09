import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fetches USD-based exchange rates from fawazahmed0/exchange-api.
class ExchangeRateRemoteDataSource {
  final http.Client _client;
  const ExchangeRateRemoteDataSource(this._client);

  static const _primary =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json';
  static const _fallback =
      'https://latest.currency-api.pages.dev/v1/currencies/usd.json';

  /// Returns `code (lowercase) -> USD rate`. Tries the primary CDN, then the
  /// fallback host. Throws if both fail.
  Future<Map<String, double>> fetchUsdRates() async {
    for (final url in const [_primary, _fallback]) {
      try {
        final res = await _client
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 10));
        if (res.statusCode != 200) continue;
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final rates = body['usd'] as Map<String, dynamic>?;
        if (rates == null) continue;
        return {
          for (final e in rates.entries)
            e.key.toLowerCase(): (e.value as num).toDouble(),
        };
      } catch (_) {
        // Try the next URL.
      }
    }
    throw Exception('Failed to fetch exchange rates');
  }
}
