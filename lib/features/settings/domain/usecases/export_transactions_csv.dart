import 'package:csv/csv.dart';

import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Serialises all transactions to a CSV string.
class ExportTransactionsCsv {
  final TransactionRepository _repository;
  const ExportTransactionsCsv(this._repository);

  Future<String> call() async {
    final transactions = await _repository.getAll();
    final rows = <List<dynamic>>[
      ['Date', 'Title', 'Type', 'Category', 'Payment Method', 'Amount', 'Note'],
      for (final t in transactions)
        [
          t.date.toIso8601String(),
          t.title,
          t.type.label,
          t.categoryLabel,
          t.paymentMethod.label,
          (t.type.isTransfer ? t.amount : t.signedAmount).toStringAsFixed(2),
          t.note ?? '',
        ],
    ];
    return const ListToCsvConverter().convert(rows);
  }
}
