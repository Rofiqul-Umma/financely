/// Erases user financial data. Used by the "forgot passcode" flow, where the
/// only safe way to regain access without the PIN is to wipe the protected data.
abstract interface class AppResetRepository {
  Future<void> wipeData();
}
