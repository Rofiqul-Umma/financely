part of 'app_lock_cubit.dart';

class AppLockState extends Equatable {
  final bool initialized;
  final bool passcodeEnabled;
  final bool biometricEnabled;
  final bool biometricAvailable;
  final bool isLocked;
  final int failedAttempts;

  /// Epoch millis until which PIN entry is blocked after too many failures.
  final int? lockoutUntil;

  /// How many lockout cooldowns have been triggered in a row; drives the
  /// escalating cooldown length. Reset to 0 on a successful unlock.
  final int lockoutCount;

  const AppLockState({
    this.initialized = false,
    this.passcodeEnabled = false,
    this.biometricEnabled = false,
    this.biometricAvailable = false,
    this.isLocked = false,
    this.failedAttempts = 0,
    this.lockoutUntil,
    this.lockoutCount = 0,
  });

  bool get canUseBiometric =>
      passcodeEnabled && biometricEnabled && biometricAvailable;

  /// Time left on the lockout cooldown, or null when not locked out.
  Duration? get lockoutRemaining {
    if (lockoutUntil == null) return null;
    final ms = lockoutUntil! - DateTime.now().millisecondsSinceEpoch;
    return ms > 0 ? Duration(milliseconds: ms) : null;
  }

  AppLockState copyWith({
    bool? initialized,
    bool? passcodeEnabled,
    bool? biometricEnabled,
    bool? biometricAvailable,
    bool? isLocked,
    int? failedAttempts,
    int? lockoutUntil,
    int? lockoutCount,
    bool clearLockout = false,
  }) {
    return AppLockState(
      initialized: initialized ?? this.initialized,
      passcodeEnabled: passcodeEnabled ?? this.passcodeEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      isLocked: isLocked ?? this.isLocked,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: clearLockout ? null : (lockoutUntil ?? this.lockoutUntil),
      lockoutCount: lockoutCount ?? this.lockoutCount,
    );
  }

  @override
  List<Object?> get props => [
        initialized,
        passcodeEnabled,
        biometricEnabled,
        biometricAvailable,
        isLocked,
        failedAttempts,
        lockoutUntil,
        lockoutCount,
      ];
}
