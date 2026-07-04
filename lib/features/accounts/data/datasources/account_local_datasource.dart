import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Thin wrapper around Drift queries for the accounts table.
class AccountLocalDataSource {
  final AppDatabase _db;
  const AccountLocalDataSource(this._db);

  Stream<List<AccountRow>> watchAll() {
    final query = _db.select(_db.accountRows)
      ..orderBy([(a) => OrderingTerm(expression: a.name)]);
    return query.watch();
  }

  Future<List<AccountRow>> getAll() {
    final query = _db.select(_db.accountRows)
      ..orderBy([(a) => OrderingTerm(expression: a.name)]);
    return query.get();
  }

  Future<void> upsert(AccountRowsCompanion row) =>
      _db.into(_db.accountRows).insertOnConflictUpdate(row);

  Future<void> insertAll(List<AccountRowsCompanion> rows) async {
    await _db.batch((batch) {
      batch.insertAll(_db.accountRows, rows);
    });
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.accountRows)..where((a) => a.id.equals(id))).go();

  Future<int> count() async {
    final countExp = _db.accountRows.id.count();
    final query = _db.selectOnly(_db.accountRows)..addColumns([countExp]);
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }
}
