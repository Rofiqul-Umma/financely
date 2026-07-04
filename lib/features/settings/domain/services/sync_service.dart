class SyncResult {
  final bool success;
  final DateTime syncedAt;
  final String message;

  const SyncResult({
    required this.success,
    required this.syncedAt,
    required this.message,
  });
}

/// Contract for cloud synchronisation. A real implementation would talk to a
/// backend; [StubSyncService] fakes it locally until that exists.
abstract interface class SyncService {
  Future<SyncResult> sync();
}
