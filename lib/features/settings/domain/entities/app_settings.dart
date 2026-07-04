import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AppSettings extends Equatable {
  final int seedColorValue;
  final ThemeMode themeMode;
  final bool useDynamicColor;
  final String currencyCode;
  final double monthlyBudget;

  const AppSettings({
    required this.seedColorValue,
    required this.themeMode,
    required this.useDynamicColor,
    required this.currencyCode,
    required this.monthlyBudget,
  });

  factory AppSettings.defaults() => AppSettings(
        seedColorValue: AppPalette.defaultSeed.toARGB32(),
        themeMode: ThemeMode.system,
        useDynamicColor: false,
        currencyCode: 'USD',
        monthlyBudget: 2000,
      );

  Color get seedColor => Color(seedColorValue);

  AppSettings copyWith({
    int? seedColorValue,
    ThemeMode? themeMode,
    bool? useDynamicColor,
    String? currencyCode,
    double? monthlyBudget,
  }) {
    return AppSettings(
      seedColorValue: seedColorValue ?? this.seedColorValue,
      themeMode: themeMode ?? this.themeMode,
      useDynamicColor: useDynamicColor ?? this.useDynamicColor,
      currencyCode: currencyCode ?? this.currencyCode,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  @override
  List<Object?> get props =>
      [seedColorValue, themeMode, useDynamicColor, currencyCode, monthlyBudget];
}
