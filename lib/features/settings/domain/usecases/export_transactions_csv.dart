import 'package:csv/csv.dart';

import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Serialises all transactions to a CSV string.
class ExportTransactionsCsv {
  final TransactionRepository _repository;
  final AccountRepository _accounts;
  const ExportTransactionsCsv(this._repository, this._accounts);

  /// Serialises transactions to CSV, optionally limited to [start]..[end]
  /// (inclusive). Passing null bounds exports the full history.
  Future<String> call({DateTime? start, DateTime? end}) async {
    final all = await _repository.getAll();
    final transactions = all.where((t) {
      if (start != null && t.date.isBefore(start)) return false;
      if (end != null && t.date.isAfter(end)) return false;
      return true;
    }).toList();
    final accounts = await _accounts.getAll();
    final names = {for (final a in accounts) a.id: a.name};

    final rows = <List<dynamic>>[
      [
        'Date',
        'Title',
        'Type',
        'Category',
        'Payment Method',
        'Account',
        'To Account',
        'Amount',
        'Note',
      ],
      for (final t in transactions)
        [
          t.date.toIso8601String(),
          t.title,
          t.type.label,
          t.categoryLabel,
          t.paymentMethod.label,
          names[t.accountId] ?? '',
          t.type.isTransfer ? (names[t.toAccountId] ?? '') : '',
          (t.type.isTransfer ? t.amount : t.signedAmount).toStringAsFixed(2),
          t.note ?? '',
        ],
    ];
    return const ListToCsvConverter().convert(rows);
  }
}
