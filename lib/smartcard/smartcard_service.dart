import 'dart:typed_data';

import 'package:cryptstorage/smartcard/mock_yubikey.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class SmartCardService {
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

  Future<Uint8List> generateECKey(KeySlot keySlot, ECCurve curve) async {
    return getService().generateECKey(keySlot, curve);
  }

  Future<Uint8List?> getECPublicKey(KeySlot keySlot) async {
    return getService().getECPublicKey(keySlot);
  }

  Future<Uint8List> sign(Uint8List data) async {
    return getService().sign(data);
  }

  Future<PinRetries> getRemainingPinTries() async {
    return getService().getRemainingPinTries();
  }

  Future<void> reset() async {
    return getService().reset();
  }
}
