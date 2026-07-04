import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class WatchTransactions {
  final TransactionRepository _repository;
  const WatchTransactions(this._repository);

  Stream<List<TransactionEntity>> call() => _repository.watchAll();
}

class AddTransaction {
  final TransactionRepository _repository;
  const AddTransaction(this._repository);

  Future<void> call(TransactionEntity transaction) =>
      _repository.add(transaction);
}

class DeleteTransaction {
  final TransactionRepository _repository;
  const DeleteTransaction(this._repository);

  Future<void> call(String id) => _repository.delete(id);
}
