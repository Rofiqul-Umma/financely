import 'package:flutter/material.dart';

import '../../domain/entities/transaction_enums.dart';

/// Icon + accent colour for each category. Kept in the presentation layer so
/// the domain enums stay free of Flutter dependencies.
extension CategoryVisuals on TransactionCategory {
  IconData get icon => switch (this) {
        TransactionCategory.food => Icons.restaurant_rounded,
        TransactionCategory.groceries => Icons.local_grocery_store_rounded,
        TransactionCategory.transport => Icons.directions_bus_rounded,
        TransactionCategory.shopping => Icons.shopping_bag_rounded,
        TransactionCategory.bills => Icons.receipt_long_rounded,
        TransactionCategory.entertainment => Icons.movie_rounded,
        TransactionCategory.health => Icons.favorite_rounded,
        TransactionCategory.housing => Icons.home_rounded,
        TransactionCategory.travel => Icons.flight_takeoff_rounded,
        TransactionCategory.education => Icons.school_rounded,
        TransactionCategory.salary => Icons.payments_rounded,
        TransactionCategory.investment => Icons.trending_up_rounded,
        TransactionCategory.gift => Icons.card_giftcard_rounded,
        TransactionCategory.other => Icons.category_rounded,
        TransactionCategory.transfer => Icons.swap_horiz_rounded,
      };

  Color get color => switch (this) {
        TransactionCategory.food => const Color(0xFFEF6C00),
        TransactionCategory.groceries => const Color(0xFF2E7D32),
        TransactionCategory.transport => const Color(0xFF1565C0),
        TransactionCategory.shopping => const Color(0xFFAD1457),
        TransactionCategory.bills => const Color(0xFF6A1B9A),
        TransactionCategory.entertainment => const Color(0xFFD81B60),
        TransactionCategory.health => const Color(0xFFC62828),
        TransactionCategory.housing => const Color(0xFF00838F),
        TransactionCategory.travel => const Color(0xFF00695C),
        TransactionCategory.education => const Color(0xFF4527A0),
        TransactionCategory.salary => const Color(0xFF2E7D32),
        TransactionCategory.investment => const Color(0xFF1B5E20),
        TransactionCategory.gift => const Color(0xFFD84315),
        TransactionCategory.other => const Color(0xFF546E7A),
        TransactionCategory.transfer => const Color(0xFF00579C),
      };
}

extension PaymentMethodVisuals on PaymentMethod {
  IconData get icon => switch (this) {
        PaymentMethod.cash => Icons.payments_outlined,
        PaymentMethod.card => Icons.credit_card_rounded,
        PaymentMethod.bank => Icons.account_balance_rounded,
      };
}
