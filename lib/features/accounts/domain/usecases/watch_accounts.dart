import '../entities/account.dart';
import '../repositories/account_repository.dart';

class WatchAccounts {
  final AccountRepository _repository;
  const WatchAccounts(this._repository);

  Stream<List<AccountEntity>> call() => _repository.watchAll();
}
