import '../../domain/services/sync_service.dart';

/// Local stand-in for cloud sync. Simulates a round-trip so the UI flow is
/// complete; swap this binding for a real client when a backend lands.
class StubSyncService implements SyncService {
  @override
  Future<SyncResult> sync() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return SyncResult(
      success: true,
      syncedAt: DateTime.now(),
      message: 'All changes backed up (local stub).',
    );
  }
}
