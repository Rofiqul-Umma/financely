import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../currency/domain/usecases/change_currency.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsRepository _repository;
  final ChangeCurrency _changeCurrency;

  SettingsCubit(this._repository, this._changeCurrency)
      : super(AppSettings.defaults());

  Future<void> load() async {
    emit(await _repository.load());
  }

  Future<void> _update(AppSettings next) async {
    emit(next);
    await _repository.save(next);
  }

  Future<void> setSeedColor(Color color) =>
      _update(state.copyWith(seedColorValue: color.toARGB32()));

  Future<void> setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  Future<void> setUseDynamicColor(bool value) =>
      _update(state.copyWith(useDynamicColor: value));

  /// Converts all stored amounts to [code] via live rates, then switches the
  /// currency. Returns false (leaving the currency unchanged) if rates can't be
  /// fetched and none are cached.
  Future<bool> setCurrency(String code) async {
    final from = state.currencyCode;
    if (from == code) return true;
    try {
      final factor = await _changeCurrency(from: from, to: code);
      await _update(state.copyWith(
        currencyCode: code,
        monthlyBudget: state.monthlyBudget * factor,
      ));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setMonthlyBudget(double budget) =>
      _update(state.copyWith(monthlyBudget: budget));

  Future<void> setLanguage(String code) =>
      _update(state.copyWith(languageCode: code));

  Future<void> setFontFamily(String family) =>
      _update(state.copyWith(fontFamily: family));

  Future<void> toggleHideBalances() =>
      _update(state.copyWith(hideBalances: !state.hideBalances));
}
