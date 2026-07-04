import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String name;

  /// ARGB colour value for the account's accent.
  final int colorValue;

  /// Index into the selectable account icon list (presentation layer).
  final int iconId;

  /// Starting balance before any transactions are applied.
  final double openingBalance;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.iconId,
    required this.openingBalance,
  });

  AccountEntity copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? iconId,
    double? openingBalance,
  }) {
    return AccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      iconId: iconId ?? this.iconId,
      openingBalance: openingBalance ?? this.openingBalance,
    );
  }

  @override
  List<Object?> get props => [id, name, colorValue, iconId, openingBalance];
}
