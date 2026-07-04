import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _local;
  const TransactionRepositoryImpl(this._local);

  @override
  Stream<List<TransactionEntity>> watchAll() =>
      _local.watchAll().map((rows) => rows.map((r) => r.toEntity()).toList());

  @override
  Future<List<TransactionEntity>> getAll() async {
    final rows = await _local.getAll();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> add(TransactionEntity transaction) =>
      _local.upsert(transaction.toCompanion());

  @override
  Future<void> update(TransactionEntity transaction) =>
      _local.upsert(transaction.toCompanion());

  @override
  Future<void> delete(String id) => _local.delete(id);
}
