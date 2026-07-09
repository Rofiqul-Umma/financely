import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/exchange_rate_repository.dart';

/// Converts every stored amount from one currency to another using live rates,
/// persisting the result. Returns the applied conversion factor so callers can
/// scale values held outside the database (e.g. the monthly budget).
class ChangeCurrency {
  final ExchangeRateRepository _rates;
  final TransactionRepository _transactions;
  final AccountRepository _accounts;

  const ChangeCurrency(this._rates, this._transactions, this._accounts);

  Future<double> call({required String from, required String to}) async {
    if (from == to) return 1;
    final rates = await _rates.usdRates();
    final factor = currencyFactor(rates, from, to);
    await _transactions.scaleAmounts(factor);
    await _accounts.scaleOpeningBalances(factor);
    return factor;
  }
}

/// Factor to multiply a [from]-denominated amount by to express it in [to],
/// derived from a USD-based rate table (`code -> units per 1 USD`).
double currencyFactor(
  Map<String, double> usdRates,
  String from,
  String to,
) {
  double usdRate(String code) {
    final c = code.toLowerCase();
    if (c == 'usd') return 1;
    final rate = usdRates[c];
    if (rate == null || rate == 0) {
      throw Exception('No exchange rate for "$code"');
    }
    return rate;
  }

  return usdRate(to) / usdRate(from);
}
