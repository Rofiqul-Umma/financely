import 'package:csv/csv.dart';

import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Serialises all transactions to a CSV string.
class ExportTransactionsCsv {
  final TransactionRepository _repository;
  final AccountRepository _accounts;
  const ExportTransactionsCsv(this._repository, this._accounts);

  Future<String> call() async {
    final transactions = await _repository.getAll();
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
