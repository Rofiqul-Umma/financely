import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Thin wrapper around Drift queries for the transaction table.
class TransactionLocalDataSource {
  final AppDatabase _db;
  const TransactionLocalDataSource(this._db);

  Stream<List<TransactionRow>> watchAll() {
    final query = _db.select(_db.transactionRows)
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ]);
    return query.watch();
  }

  Future<List<TransactionRow>> getAll() {
    final query = _db.select(_db.transactionRows)
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ]);
    return query.get();
  }

  Future<void> upsert(TransactionRowsCompanion row) =>
      _db.into(_db.transactionRows).insertOnConflictUpdate(row);

  Future<void> insertAll(List<TransactionRowsCompanion> rows) async {
    await _db.batch((batch) {
      batch.insertAll(_db.transactionRows, rows);
    });
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.transactionRows)..where((t) => t.id.equals(id))).go();

  Future<int> count() async {
    final countExp = _db.transactionRows.id.count();
    final query = _db.selectOnly(_db.transactionRows)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
