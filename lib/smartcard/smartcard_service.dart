import 'dart:typed_data';

import 'package:cryptstorage/smartcard/mock_yubikey.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class SmartCardService implements YubikitOpenPGP {
  final YubikitOpenPGP _yubikitOpenPGP;
  final MockYubikitOpenPGP _mockYubikitOpenPGP;
  final SharedPreferences _preferences;
  final SmartCardInterface _interface;

  SmartCardService(
      {SmartCardInterface? interface,
      PinProvider? pinProvider,
      SharedPreferences? preferences})
      : _interface = interface ?? GetIt.I.get(),
        _preferences = preferences ?? GetIt.I.get(),
        _yubikitOpenPGP =
            YubikitFlutter.openPGP(pinProvider: pinProvider ?? GetIt.I.get()),
        _mockYubikitOpenPGP = MockYubikitOpenPGP(pinProvider: pinProvider);

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

  Future<Map<KeySlot, KeyData?>> getAllKeys() async {
    const cmds = YubikitOpenPGPCommands();
    final commands = [
      cmds.getAsymmetricPublicKey(KeySlot.signature),
      cmds.getAsymmetricPublicKey(KeySlot.encryption),
      cmds.getAsymmetricPublicKey(KeySlot.authentication),
    ];
    final results =
        await _interface.sendCommands(Application.openpgp, commands);
    final result = await results.toList();
    final entries = <MapEntry<KeySlot, KeyData?>>[];
    entries.add(_keyEntry(KeySlot.signature, result[0]));
    entries.add(_keyEntry(KeySlot.encryption, result[1]));
    entries.add(_keyEntry(KeySlot.authentication, result[2]));
    return Map.fromEntries(entries);
  }

  MapEntry<KeySlot, KeyData?> _keyEntry(
      KeySlot keySlot, SmartCardResponse response) {
    if (response is SuccessfulResponse) {
      return MapEntry(keySlot, KeyData.fromBytes(response.response, keySlot));
    }
    return MapEntry(keySlot, null);
  }

  @override
  Future<PinRetries> getRemainingPinTries() async =>
      getService().getRemainingPinTries();

  @override
  Future<void> reset() async {
    if (isMock()) {
      return getService().reset();
    }
    return _batchReset();
  }

  Future<void> _batchReset() async {
    const cmds = YubikitOpenPGPCommands();
    final commands = [..._blockPins(), cmds.terminate(), cmds.activate()];
    await _interface.sendCommands(Application.openpgp, commands);
  }

  List<Uint8List> _blockPins() {
    const cmds = YubikitOpenPGPCommands();
    var invalidPin = '00000000';
    final pinCmds = Iterable.generate(9)
        .map((e) => cmds.verifySignaturePin(invalidPin))
        .toList();
    final adminPinCmds = Iterable.generate(9)
        .map((e) => cmds.verifyAdminPin(invalidPin))
        .toList();
    return pinCmds + adminPinCmds;
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
  Future<TouchMode> getTouch(KeySlot keySlot) => getService().getTouch(keySlot);

  @override
  Future<void> setPinRetries(int pw1Tries, int pw2Tries, int pw3Tries) =>
      getService().setPinRetries(pw1Tries, pw2Tries, pw3Tries);

  @override
  Future<void> setTouch(KeySlot keySlot, TouchMode mode) =>
      getService().setTouch(keySlot, mode);

  @override
  Future<Uint8List> ecSign(List<int> data) => getService().ecSign(data);

  @override
  Future<ECKeyData> generateECKey(KeySlot keySlot, ECCurve curve,
          [int? timestamp]) =>
      getService().generateECKey(keySlot, curve);

  @override
  Future<RSAKeyData> generateRSAKey(KeySlot keySlot, int keySize,
          [int? timestamp]) =>
      getService().generateRSAKey(keySlot, keySize);

  @override
  Future<KeyData?> getPublicKey(KeySlot keySlot) =>
      getService().getPublicKey(keySlot);

  @override
  Future<Uint8List> rsaSign(List<int> data) async => getService().rsaSign(data);

  @override
  Future<Uint8List> decipher(List<int> ciphertext) =>
      getService().decipher(ciphertext);
}
