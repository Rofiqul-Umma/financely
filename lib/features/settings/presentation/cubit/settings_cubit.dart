import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(AppSettings.defaults());

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

  Future<void> setCurrency(String code) =>
      _update(state.copyWith(currencyCode: code));

  Future<void> setMonthlyBudget(double budget) =>
      _update(state.copyWith(monthlyBudget: budget));

  Future<void> setLanguage(String code) =>
      _update(state.copyWith(languageCode: code));
}
