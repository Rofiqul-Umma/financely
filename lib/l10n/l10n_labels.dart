import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../features/transactions/domain/entities/transaction.dart';
import '../features/transactions/domain/entities/transaction_enums.dart';
import 'app_localizations.dart';

/// Localized display labels for the domain enums. The plain `.label` getters on
/// the enums stay English-only for context-free callers (e.g. CSV export).
extension TransactionTypeL10n on TransactionType {
  String localizedLabel(AppLocalizations l) => switch (this) {
        TransactionType.expense => l.typeExpense,
        TransactionType.income => l.typeIncome,
        TransactionType.transfer => l.typeTransfer,
      };
}

extension PaymentMethodL10n on PaymentMethod {
  String localizedLabel(AppLocalizations l) => switch (this) {
        PaymentMethod.cash => l.paymentCash,
        PaymentMethod.card => l.paymentCard,
        PaymentMethod.bank => l.paymentBank,
      };
}

extension TransactionCategoryL10n on TransactionCategory {
  String localizedLabel(AppLocalizations l) => switch (this) {
        TransactionCategory.food => l.catFood,
        TransactionCategory.groceries => l.catGroceries,
        TransactionCategory.transport => l.catTransport,
        TransactionCategory.shopping => l.catShopping,
        TransactionCategory.bills => l.catBills,
        TransactionCategory.entertainment => l.catEntertainment,
        TransactionCategory.health => l.catHealth,
        TransactionCategory.housing => l.catHousing,
        TransactionCategory.travel => l.catTravel,
        TransactionCategory.education => l.catEducation,
        TransactionCategory.salary => l.catSalary,
        TransactionCategory.investment => l.catInvestment,
        TransactionCategory.gift => l.catGift,
        TransactionCategory.other => l.catOther,
        TransactionCategory.transfer => l.catTransfer,
      };
}

extension TransactionEntityL10n on TransactionEntity {
  /// The custom label when set, otherwise the localized category name.
  String localizedCategoryLabel(AppLocalizations l) {
    final custom = customLabel?.trim();
    return (custom != null && custom.isNotEmpty)
        ? custom
        : category.localizedLabel(l);
  }
}

/// Day heading that reads "Today"/"Yesterday" for recent dates and falls back to
/// a locale-aware weekday or month/day for older ones.
String localizedRelativeDate(BuildContext context, DateTime date) {
  final l = AppLocalizations.of(context);
  final locale = Localizations.localeOf(context).languageCode;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(date.year, date.month, date.day);
  final diff = today.difference(that).inDays;
  if (diff == 0) return l.today;
  if (diff == 1) return l.yesterday;
  if (diff < 7) return DateFormat.EEEE(locale).format(date);
  return DateFormat.MMMd(locale).format(date);
}
