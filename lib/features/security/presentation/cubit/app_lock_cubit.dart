import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/repositories/app_reset_repository.dart';
import '../../domain/repositories/passcode_repository.dart';

part 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  static const int maxAttempts = 5;

  /// Escalating cooldowns applied on each successive lockout; the last entry
  /// repeats once exhausted.
  static const List<Duration> lockoutSchedule = [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 5),
  ];

  final PasscodeRepository _repository;
  final AppResetRepository _reset;
  final LocalAuthentication _auth;

  AppLockCubit(this._repository, this._reset, {LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication(),
        super(const AppLockState());

  /// Loads persisted config and locks the app if a passcode is set.
  Future<void> init() async {
    final enabled = await _repository.isEnabled();
    final biometricPref = await _repository.isBiometricEnabled();
    final biometricAvailable = await _biometricSupported();
    emit(
      AppLockState(
        initialized: true,
        passcodeEnabled: enabled,
        biometricEnabled: biometricPref,
        biometricAvailable: biometricAvailable,
        isLocked: enabled,
      ),
    );
  }

  /// Re-lock when the app returns from the background.
  void lock() {
    if (state.passcodeEnabled && !state.isLocked) {
      emit(state.copyWith(isLocked: true, failedAttempts: 0));
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    if (state.lockoutRemaining != null) return false;
    final ok = await _repository.verify(pin);
    if (ok) {
      emit(state.copyWith(
        isLocked: false,
        failedAttempts: 0,
        lockoutCount: 0,
        clearLockout: true,
      ));
    } else {
      final attempts = state.failedAttempts + 1;
      if (attempts >= maxAttempts) {
        final level = state.lockoutCount.clamp(0, lockoutSchedule.length - 1);
        final cooldown = lockoutSchedule[level];
        emit(state.copyWith(
          failedAttempts: 0,
          lockoutCount: state.lockoutCount + 1,
          lockoutUntil: DateTime.now().add(cooldown).millisecondsSinceEpoch,
        ));
      } else {
        emit(state.copyWith(failedAttempts: attempts));
      }
    }
    return ok;
  }

  /// Clears any expired lockout so the UI re-enables the keypad.
  void refreshLockout() {
    if (state.lockoutUntil != null && state.lockoutRemaining == null) {
      emit(state.copyWith(clearLockout: true));
    }
  }

  /// Last-resort recovery: wipes protected data and removes the passcode, since
  /// there is no way to prove ownership of a forgotten local PIN.
  Future<void> forgotPasscode() async {
    await _reset.wipeData();
    await _repository.disable();
    emit(state.copyWith(
      passcodeEnabled: false,
      biometricEnabled: false,
      isLocked: false,
      failedAttempts: 0,
      clearLockout: true,
    ));
  }

  Future<bool> unlockWithBiometric() async {
    if (!state.canUseBiometric) return false;
    final ok = await _authenticate();
    if (ok) {
      emit(state.copyWith(
        isLocked: false,
        failedAttempts: 0,
        lockoutCount: 0,
        clearLockout: true,
      ));
    }
    return ok;
  }

  Future<void> enablePasscode(String pin) async {
    await _repository.setPasscode(pin);
    emit(state.copyWith(passcodeEnabled: true, isLocked: false));
  }

  Future<void> changePasscode(String pin) async {
    await _repository.setPasscode(pin);
  }

  Future<void> disablePasscode() async {
    await _repository.disable();
    emit(
      state.copyWith(
        passcodeEnabled: false,
        biometricEnabled: false,
        isLocked: false,
      ),
    );
  }

  /// Turns biometric unlock on/off. Enabling requires a successful auth so we
  /// never store a preference the device can't satisfy.
  Future<bool> setBiometricEnabled(bool value) async {
    if (value) {
      if (!state.biometricAvailable) return false;
      final ok = await _authenticate();
      if (!ok) return false;
    }
    await _repository.setBiometricEnabled(value);
    emit(state.copyWith(biometricEnabled: value));
    return true;
  }

  Future<bool> _biometricSupported() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock Financely',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
