import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Persistent store for logged transactions.
class TransactionRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();

  /// 0 = expense, 1 = income (TransactionType.index).
  IntColumn get type => integer()();

  /// TransactionCategory.index
  IntColumn get category => integer()();

  /// Optional user-defined category name (used with the "Other" category).
  TextColumn get customLabel => text().nullable()();

  /// PaymentMethod.index
  IntColumn get paymentMethod => integer()();

  /// Owning account (source account for transfers). References AccountRows.id.
  TextColumn get accountId => text().nullable()();

  /// Destination account, set only for transfers. References AccountRows.id.
  TextColumn get toAccountId => text().nullable()();

  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-managed money accounts (wallets, bank accounts, cards).
class AccountRows extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// ARGB colour value for the account's accent.
  IntColumn get colorValue => integer()();

  /// Index into the selectable account icon list (presentation layer).
  IntColumn get iconId => integer()();

  /// Starting balance before any transactions are applied.
  RealColumn get openingBalance => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TransactionRows, AccountRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(transactionRows, transactionRows.customLabel);
          }
          if (from < 3) {
            await m.createTable(accountRows);
            await m.addColumn(transactionRows, transactionRows.accountId);
            await m.addColumn(transactionRows, transactionRows.toAccountId);
          }
        },
      );

  static QueryExecutor _openConnection() => driftDatabase(
        name: 'material_ledger',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );
}
