import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_labels.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_enums.dart';
import '../utils/category_visuals.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final String currencyCode;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.currencyCode,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final isIncome = transaction.type == TransactionType.income;
    final isTransfer = transaction.type == TransactionType.transfer;
    final amountColor = isIncome
        ? const Color(0xFF2E7D32)
        : isTransfer
            ? scheme.onSurfaceVariant
            : scheme.onSurface;
    final amountText = isTransfer
        ? Formatters.currency(transaction.amount, code: currencyCode)
        : Formatters.signedCurrency(transaction.signedAmount,
            code: currencyCode);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: transaction.category.color.withValues(alpha: 0.15),
        child: Icon(transaction.category.icon,
            color: transaction.category.color, size: 22),
      ),
      title: Text(
        transaction.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${transaction.localizedCategoryLabel(l)} · ${localizedRelativeDate(context, transaction.date)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 120),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                amountText,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Icon(transaction.paymentMethod.icon,
              size: 14, color: scheme.onSurfaceVariant),
        ],
      ),
      onTap: onTap,
      onLongPress: onDelete,
    );
  }
}
