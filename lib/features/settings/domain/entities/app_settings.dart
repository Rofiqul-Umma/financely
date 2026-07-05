import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AppSettings extends Equatable {
  final int seedColorValue;
  final ThemeMode themeMode;
  final bool useDynamicColor;
  final String currencyCode;
  final double monthlyBudget;

  /// UI language, as an ISO code ('en' or 'id').
  final String languageCode;

  /// Font family name as registered in pubspec.yaml.
  final String fontFamily;

  const AppSettings({
    required this.seedColorValue,
    required this.themeMode,
    required this.useDynamicColor,
    required this.currencyCode,
    required this.monthlyBudget,
    required this.languageCode,
    required this.fontFamily,
  });

  factory AppSettings.defaults() => AppSettings(
        seedColorValue: AppPalette.defaultSeed.toARGB32(),
        themeMode: ThemeMode.system,
        useDynamicColor: false,
        currencyCode: 'USD',
        monthlyBudget: 2000,
        languageCode: 'en',
        fontFamily: 'Roboto',
      );

  Color get seedColor => Color(seedColorValue);

  AppSettings copyWith({
    int? seedColorValue,
    ThemeMode? themeMode,
    bool? useDynamicColor,
    String? currencyCode,
    double? monthlyBudget,
    String? languageCode,
    String? fontFamily,
  }) {
    return AppSettings(
      seedColorValue: seedColorValue ?? this.seedColorValue,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      currencyCode: currencyCode ?? this.currencyCode,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      languageCode: languageCode ?? this.languageCode,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  @override
  List<Object?> get props => [
        seedColorValue,
        themeMode,
        useDynamicColor,
        currencyCode,
        monthlyBudget,
        languageCode,
        fontFamily,
      ];
}
