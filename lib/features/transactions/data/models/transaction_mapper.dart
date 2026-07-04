import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_enums.dart';

/// Maps between the Drift row model and the pure domain entity.
extension TransactionRowMapper on TransactionRow {
  TransactionEntity toEntity() => TransactionEntity(
        id: id,
        title: title,
        amount: amount,
        type: TransactionType.values[type],
        category: TransactionCategory.values[category],
        customLabel: customLabel,
        paymentMethod: PaymentMethod.values[paymentMethod],
        accountId: accountId,
        toAccountId: toAccountId,
        date: date,
        note: note,
      );
}

extension TransactionEntityMapper on TransactionEntity {
  TransactionRowsCompanion toCompanion() => TransactionRowsCompanion(
        id: Value(id),
        title: Value(title),
        amount: Value(amount),
        type: Value(type.index),
        category: Value(category.index),
        customLabel: Value(customLabel),
        paymentMethod: Value(paymentMethod.index),
        accountId: Value(accountId),
        toAccountId: Value(toAccountId),
        date: Value(date),
        note: Value(note),
      );
}
