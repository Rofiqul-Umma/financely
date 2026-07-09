import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/exchange_rate_repository.dart';
import 'exchange_rate_remote_datasource.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateRemoteDataSource _remote;
  final SharedPreferences _prefs;
  const ExchangeRateRepositoryImpl(this._remote, this._prefs);

  static const _kCache = 'fx.usdRates';

  @override
  Future<Map<String, double>> usdRates() async {
    try {
      final rates = await _remote.fetchUsdRates();
      await _prefs.setString(_kCache, jsonEncode(rates));
      return rates;
    } catch (_) {
      final cached = _prefs.getString(_kCache);
      if (cached != null) {
        final map = jsonDecode(cached) as Map<String, dynamic>;
        return {
          for (final e in map.entries) e.key: (e.value as num).toDouble(),
        };
      }
      rethrow;
    }
  }
}
