import 'package:csv/csv.dart';
import 'package:uuid/uuid.dart';

import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/entities/transaction_enums.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';

/// Reads a CSV produced by [ExportTransactionsCsv] and appends its rows as new
/// transactions. Each row is given a fresh id, so re-importing the same file
/// duplicates its rows rather than merging them.
class ImportTransactionsCsv {
  final AccountRepository _accounts;
  final TransactionRepository _transactions;
  const ImportTransactionsCsv(this._accounts, this._transactions);

  static const _uuid = Uuid();

  /// Parses [csv] and inserts every valid row. Malformed rows are skipped.
  /// Returns the number of transactions imported.
  Future<int> call(String csv) async {
    final rows = const CsvToListConverter(shouldParseNumbers: false).convert(csv);
    if (rows.isEmpty) return 0;

    // Resolve accounts by name, creating any that don't exist yet.
    final existing = await _accounts.getAll();
    final idByName = <String, String>{
      for (final a in existing) a.name.toLowerCase(): a.id,
    };

    Future<String?> accountIdFor(String rawName) async {
      final name = rawName.trim();
      if (name.isEmpty) return null;
      final key = name.toLowerCase();
      final found = idByName[key];
      if (found != null) return found;
      final account = AccountEntity(
        id: _uuid.v4(),
        name: name,
        colorValue: 0xFF607D8B,
        iconId: 0,
        openingBalance: 0,
      );
      await _accounts.add(account);
      idByName[key] = account.id;
      return account.id;
    }

    var count = 0;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i].map((c) => c.toString()).toList();
      // Skip the header row emitted by the exporter.
      if (i == 0 && row.isNotEmpty && row.first.toLowerCase() == 'date') {
        continue;
      }
      if (row.length < 8) continue;

      final date = DateTime.tryParse(row[0].trim());
      if (date == null) continue;

      final type = _typeFrom(row[2]);
      final (category, customLabel) = _categoryFrom(row[3]);
      final method = _methodFrom(row[4]);
      final amount = double.tryParse(row[7].trim());
      if (amount == null) continue;

      final accountId = await accountIdFor(row[5]);
      final toAccountId =
          type.isTransfer ? await accountIdFor(row[6]) : null;

      await _transactions.add(TransactionEntity(
        id: _uuid.v4(),
        title: row[1].trim(),
        amount: amount.abs(),
        type: type,
        category: category,
        customLabel: customLabel,
        paymentMethod: method,
        accountId: accountId,
        toAccountId: toAccountId,
        date: date,
        note: row.length > 8 && row[8].trim().isNotEmpty ? row[8].trim() : null,
      ));
      count++;
    }
    return count;
  }

  TransactionType _typeFrom(String label) {
    final v = label.trim().toLowerCase();
    return TransactionType.values.firstWhere(
      (t) => t.label.toLowerCase() == v,
      orElse: () => TransactionType.expense,
    );
  }

  PaymentMethod _methodFrom(String label) {
    final v = label.trim().toLowerCase();
    return PaymentMethod.values.firstWhere(
      (m) => m.label.toLowerCase() == v,
      orElse: () => PaymentMethod.cash,
    );
  }

  /// Maps a category cell back to an enum. Unknown values (custom "Other"
  /// labels the user typed) fall back to [TransactionCategory.other] with the
  /// original text kept as the custom label.
  (TransactionCategory, String?) _categoryFrom(String label) {
    final v = label.trim();
    for (final c in TransactionCategory.values) {
      if (c.label.toLowerCase() == v.toLowerCase()) return (c, null);
    }
    if (v.isEmpty) return (TransactionCategory.other, null);
    return (TransactionCategory.other, v);
  }
}
