abstract interface class ExchangeRateRepository {
  /// USD-based rates: `code (lowercase) -> units of that currency per 1 USD`.
  /// Returns freshly fetched rates when online, otherwise the last cached set.
  /// Throws when rates cannot be fetched and nothing is cached.
  Future<Map<String, double>> usdRates();
}
