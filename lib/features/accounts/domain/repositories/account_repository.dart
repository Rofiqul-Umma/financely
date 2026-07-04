import '../entities/account.dart';

abstract interface class AccountRepository {
  /// Emits the account list on every change.
  Stream<List<AccountEntity>> watchAll();

  Future<List<AccountEntity>> getAll();

  Future<void> add(AccountEntity account);

  Future<void> delete(String id);
}
