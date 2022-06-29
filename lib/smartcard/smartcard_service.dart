import 'dart:typed_data';

import 'package:cryptstorage/smartcard/mock_yubikey.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class SmartCardService implements YubikitOpenPGP, YubikitOpenPGPBatch {
  final YubikitOpenPGP _yubikitOpenPGP;
  final YubikitOpenPGPBatch _yubikitOpenPGPBatch;
  final MockYubikitOpenPGP _mockYubikitOpenPGP;
  final SharedPreferences _preferences;

  SmartCardService(
      {SmartCardInterface? interface,
      PinProvider? pinProvider,
      SharedPreferences? preferences})
      : _preferences = preferences ?? GetIt.I.get(),
        _yubikitOpenPGP =
            YubikitFlutter.openPGP(pinProvider: pinProvider ?? GetIt.I.get()),
        _yubikitOpenPGPBatch = YubikitFlutter.openPGPBatch(
            pinProvider: pinProvider ?? GetIt.I.get()),
        _mockYubikitOpenPGP = MockYubikitOpenPGP(pinProvider: pinProvider);

  YubikitOpenPGP getService() {
    if (_preferences.getBool('yubikeyMock') ?? false) {
      return _mockYubikitOpenPGP;
    }
    return _yubikitOpenPGP;
  }

  YubikitOpenPGPBatch getBatchService() {
    if (_preferences.getBool('yubikeyMock') ?? false) {
      return _mockYubikitOpenPGP;
    }
    return _yubikitOpenPGPBatch;
  }

  Future<void> toggleMock() async {
    await _preferences.setBool(
        'yubikeyMock', !(_preferences.getBool('yubikeyMock') ?? false));
  }

  bool isMock() {
    return _preferences.getBool('yubikeyMock') ?? false;
  }

  @override
  Future<Map<KeySlot, KeyData?>> getAllPublicKeys() async {
    return getService().getAllPublicKeys();
  }

  @override
  Future<PinRetries> getRemainingPinTries() async =>
      getService().getRemainingPinTries();

  @override
  Future<void> reset() async {
    return getService().reset();
  }

  @override
  Future<Uint8List> ecSharedSecret(List<int> publicKey) =>
      getService().ecSharedSecret(publicKey);

  @override
  Future<ApplicationVersion> getApplicationVersion() =>
      getService().getApplicationVersion();

  @override
  Future<OpenPGPVersion> getOpenPGPVersion() =>
      getService().getOpenPGPVersion();

  @override
  Future<TouchMode> getTouchMode(KeySlot keySlot) => getService().getTouchMode(keySlot);

  @override
  Future<void> setRemainingPinTries(int pw1Tries, int pw2Tries, int pw3Tries) =>
      getService().setRemainingPinTries(pw1Tries, pw2Tries, pw3Tries);

  @override
  Future<void> setTouchMode(KeySlot keySlot, TouchMode mode) =>
      getService().setTouchMode(keySlot, mode);

  @override
  Future<Uint8List> ecSign(List<int> data) => getService().ecSign(data);

  @override
  Future<ECKeyData> generateECKey(KeySlot keySlot, ECCurve curve,
          [int? timestamp]) =>
      getService().generateECKey(keySlot, curve);

  @override
  Future<RSAKeyData> generateRSAKey(KeySlot keySlot, int keySize,
      [int? timestamp]) {
    return getService().generateRSAKey(keySlot, keySize);
  }

  @override
  Future<KeyData?> getPublicKey(KeySlot keySlot) =>
      getService().getPublicKey(keySlot);

  @override
  Future<Uint8List> rsaSign(List<int> data) async => getService().rsaSign(data);

  @override
  Future<Uint8List> decipher(List<int> ciphertext) =>
      getService().decipher(ciphertext);

  @override
  Future<Map<KeySlot, ECKeyData>> generateECKeys(Map<KeySlot, ECCurve> slots) {
    return getBatchService().generateECKeys(slots);
  }

  @override
  Future<Map<KeySlot, KeyData?>> getKeys(List<KeySlot> keySlots) {
    return getBatchService().getKeys(keySlots);
  }

  @override
  Future<Map<KeySlot, RSAKeyData>> generateRSAKeys(
      Map<KeySlot, int> rsaParams) {
    return getBatchService().generateRSAKeys(rsaParams);
  }
}
