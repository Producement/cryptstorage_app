import 'dart:typed_data';

import 'package:cryptstorage/smartcard/mock_yubikey.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class SmartCardService implements YubikitOpenPGP {
  final YubikitOpenPGP _yubikitOpenPGP;
  final MockYubikitOpenPGP _mockYubikitOpenPGP;
  final SharedPreferences _preferences;

  SmartCardService(
      {YubikitOpenPGP? yubikitOpenPGP,
      MockYubikitOpenPGP? mockYubikitOpenPGP,
      SharedPreferences? preferences})
      : _yubikitOpenPGP = yubikitOpenPGP ?? GetIt.I.get(),
        _preferences = preferences ?? GetIt.I.get(),
        _mockYubikitOpenPGP = mockYubikitOpenPGP ?? GetIt.I.get();

  YubikitOpenPGP getService() {
    if (_preferences.getBool('yubikeyMock') ?? false) {
      return _mockYubikitOpenPGP;
    }
    return _yubikitOpenPGP;
  }

  Future<void> toggleMock() async {
    await _preferences.setBool(
        'yubikeyMock', !(_preferences.getBool('yubikeyMock') ?? false));
  }

  bool isMock() {
    return _preferences.getBool('yubikeyMock') ?? false;
  }

  @override
  Future<PinRetries> getRemainingPinTries() async {
    return getService().getRemainingPinTries();
  }

  @override
  Future<void> reset() async {
    return getService().reset();
  }

  @override
  Future<Uint8List> ecSharedSecret(List<int> publicKey) {
    return getService().ecSharedSecret(publicKey);
  }

  @override
  Future<Tuple3<int, int, int>> getApplicationVersion() {
    return getService().getApplicationVersion();
  }

  @override
  Future<Tuple2<int, int>> getOpenPGPVersion() {
    return getService().getOpenPGPVersion();
  }

  @override
  Future<TouchMode> getTouch(KeySlot keySlot) {
    return getService().getTouch(keySlot);
  }

  @override
  Future<void> setPinRetries(int pw1Tries, int pw2Tries, int pw3Tries) {
    return getService().setPinRetries(pw1Tries, pw2Tries, pw3Tries);
  }

  @override
  Future<void> setTouch(KeySlot keySlot, TouchMode mode) {
    return getService().setTouch(keySlot, mode);
  }

  @override
  Future<Uint8List> ecSign(List<int> data) {
    return getService().ecSign(data);
  }

  @override
  Future<ECKeyData> generateECKey(KeySlot keySlot, ECCurve curve,
      [int? timestamp]) {
    return getService().generateECKey(keySlot, curve);
  }

  @override
  Future<RSAKeyData> generateRSAKey(KeySlot keySlot, int keySize,
      [int? timestamp]) {
    return getService().generateRSAKey(keySlot, keySize);
  }

  @override
  Future<KeyData?> getPublicKey(KeySlot keySlot) {
    return getService().getPublicKey(keySlot);
  }

  @override
  Future<Uint8List> rsaSign(List<int> data) async {
    return getService().rsaSign(data);
  }
}
