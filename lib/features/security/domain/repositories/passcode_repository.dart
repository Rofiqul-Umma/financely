/// Stores and verifies the app passcode plus the biometric preference.
abstract interface class PasscodeRepository {
  Future<bool> isEnabled();

  Future<bool> isBiometricEnabled();

  /// Hashes and stores [pin], marking the passcode as enabled.
  Future<void> setPasscode(String pin);

  /// Clears the passcode and disables both passcode and biometric.
  Future<void> disable();

  Future<bool> verify(String pin);

  Future<void> setBiometricEnabled(bool value);
}
