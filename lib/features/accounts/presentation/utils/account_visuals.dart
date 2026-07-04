import 'package:flutter/material.dart';

import '../../domain/entities/account.dart';

/// Selectable icons for accounts. Stored by index (AccountEntity.iconId) so the
/// domain layer stays free of Flutter types.
const List<IconData> kAccountIcons = <IconData>[
  Icons.account_balance_wallet_rounded, // 0 - cash / wallet
  Icons.account_balance_rounded, // 1 - bank
  Icons.credit_card_rounded, // 2 - card
  Icons.savings_rounded, // 3 - savings
  Icons.payments_rounded, // 4 - cash stack
  Icons.currency_exchange_rounded, // 5 - exchange
  Icons.phone_iphone_rounded, // 6 - e-wallet
  Icons.attach_money_rounded, // 7 - money
];

/// Selectable accent colours for accounts.
const List<Color> kAccountColors = <Color>[
  Color(0xFF2E7D32),
  Color(0xFF1565C0),
  Color(0xFF6A1B9A),
  Color(0xFFAD1457),
  Color(0xFFEF6C00),
  Color(0xFF00838F),
  Color(0xFF4527A0),
  Color(0xFFC62828),
];

extension AccountVisuals on AccountEntity {
  IconData get icon =>
      kAccountIcons[iconId.clamp(0, kAccountIcons.length - 1)];

  Color get color => Color(colorValue);
}
