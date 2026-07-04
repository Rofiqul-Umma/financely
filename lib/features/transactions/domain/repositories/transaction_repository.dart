import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  /// Emits the full transaction list, newest first, on every change.
  Stream<List<TransactionEntity>> watchAll();

  Future<List<TransactionEntity>> getAll();

  Future<void> add(TransactionEntity transaction);

  Future<void> update(TransactionEntity transaction);

  Future<void> delete(String id);
}
