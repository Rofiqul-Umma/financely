import '../../../../core/database/app_database.dart';
import '../domain/repositories/app_reset_repository.dart';

class AppResetRepositoryImpl implements AppResetRepository {
  final AppDatabase _db;
  const AppResetRepositoryImpl(this._db);

  @override
  Future<void> wipeData() async {
    await _db.transaction(() async {
      await _db.delete(_db.transactionRows).go();
      await _db.delete(_db.accountRows).go();
    });
  }
}
