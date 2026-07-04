import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_datasource.dart';
import '../models/account_mapper.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _local;
  const AccountRepositoryImpl(this._local);

  @override
  Stream<List<AccountEntity>> watchAll() =>
      _local.watchAll().map((rows) => rows.map((r) => r.toEntity()).toList());

  @override
  Future<List<AccountEntity>> getAll() async {
    final rows = await _local.getAll();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<void> add(AccountEntity account) =>
      _local.upsert(account.toCompanion());

  @override
  Future<void> delete(String id) => _local.delete(id);
}
