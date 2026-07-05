import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/passcode_repository.dart';

class PasscodeRepositoryImpl implements PasscodeRepository {
  final SharedPreferences _prefs;
  const PasscodeRepositoryImpl(this._prefs);

  static const _kEnabled = 'security.passcodeEnabled';
  static const _kBiometric = 'security.biometricEnabled';
  static const _kHash = 'security.pinHash';
  static const _kSalt = 'security.pinSalt';

  @override
  Future<bool> isEnabled() async => _prefs.getBool(_kEnabled) ?? false;

  @override
  Future<bool> isBiometricEnabled() async =>
      _prefs.getBool(_kBiometric) ?? false;

  @override
  Future<void> setPasscode(String pin) async {
    final salt = _randomSalt();
    await _prefs.setString(_kSalt, salt);
    await _prefs.setString(_kHash, _hash(pin, salt));
    await _prefs.setBool(_kEnabled, true);
  }

  @override
  Future<void> disable() async {
    await _prefs.remove(_kHash);
    await _prefs.remove(_kSalt);
    await _prefs.setBool(_kEnabled, false);
    await _prefs.setBool(_kBiometric, false);
  }

  @override
  Future<bool> verify(String pin) async {
    final salt = _prefs.getString(_kSalt);
    final stored = _prefs.getString(_kHash);
    if (salt == null || stored == null) return false;
    return _hash(pin, salt) == stored;
  }

  @override
  Future<void> setBiometricEnabled(bool value) async {
    await _prefs.setBool(_kBiometric, value);
  }

  String _randomSalt() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return base64Encode(bytes);
  }

  String _hash(String pin, String salt) {
    return sha256.convert(utf8.encode('$salt:$pin')).toString();
  }
}
