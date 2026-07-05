import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/app_settings.dart';
import '../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SharedPreferences _prefs;
  const SettingsRepositoryImpl(this._prefs);

  static const _kSeed = 'settings.seedColor';
  static const _kThemeMode = 'settings.themeMode';
  static const _kDynamic = 'settings.useDynamicColor';
  static const _kCurrency = 'settings.currency';
  static const _kBudget = 'settings.monthlyBudget';
  static const _kLanguage = 'settings.language';
  static const _kFont = 'settings.fontFamily';

  @override
  Future<AppSettings> load() async {
    final defaults = AppSettings.defaults();
    return AppSettings(
      seedColorValue: _prefs.getInt(_kSeed) ?? defaults.seedColorValue,
      themeMode: ThemeMode.values[
          _prefs.getInt(_kThemeMode) ?? defaults.themeMode.index],
      useDynamicColor: _prefs.getBool(_kDynamic) ?? defaults.useDynamicColor,
      currencyCode: _prefs.getString(_kCurrency) ?? defaults.currencyCode,
      monthlyBudget: _prefs.getDouble(_kBudget) ?? defaults.monthlyBudget,
      languageCode: _prefs.getString(_kLanguage) ?? defaults.languageCode,
      fontFamily: _prefs.getString(_kFont) ?? defaults.fontFamily,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _prefs.setInt(_kSeed, settings.seedColorValue),
      _prefs.setInt(_kThemeMode, settings.themeMode.index),
      _prefs.setBool(_kDynamic, settings.useDynamicColor),
      _prefs.setString(_kCurrency, settings.currencyCode),
      _prefs.setDouble(_kBudget, settings.monthlyBudget),
      _prefs.setString(_kLanguage, settings.languageCode),
      _prefs.setString(_kFont, settings.fontFamily),
    ]);
  }
}
