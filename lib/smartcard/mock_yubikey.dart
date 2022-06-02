import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class MockYubikitOpenPGP implements YubikitOpenPGP {
  static const mockSigningKeyPreference = 'mockSigningSeed';
  static const mockEncryptionSeedPreference = 'mockEncryptionSeed';
  final PinProvider _pinProvider;
  final SharedPreferences _preferences;
  static final signingAlgorithm = Ed25519();
  static final encryptionAlgorithm = X25519();
  SimpleKeyPair? _signingKeyPair;
  SimpleKeyPair? _encryptionKeyPair;
  int pinTries = 3, adminPinTries = 3;

  MockYubikitOpenPGP({PinProvider? pinProvider, SharedPreferences? preferences})
      : _pinProvider = pinProvider ?? GetIt.I.get(),
        _preferences = preferences ?? GetIt.I.get() {
    final signingSeed = _preferences.getString(mockSigningKeyPreference);
    if (signingSeed != null) {
      signingAlgorithm
          .newKeyPairFromSeed(base64Decode(signingSeed))
          .then((value) => _signingKeyPair = value);
    }
    final encryptionSeed = _preferences.getString(mockEncryptionSeedPreference);
    if (encryptionSeed != null) {
      encryptionAlgorithm
          .newKeyPairFromSeed(base64Decode(encryptionSeed))
          .then((value) => _encryptionKeyPair = value);
    }
  }

  void verifyAdminPin() {
    if (adminPinTries == 0) {
      throw const SmartCardException(0x69, 0x83);
    }
    if (_pinProvider.adminPin != YubikitOpenPGP.defaultAdminPin) {
      adminPinTries -= 1;
      throw const SmartCardException(0x69, 0x82);
    }
  }

  void verifyPin() {
    if (pinTries == 0) {
      throw const SmartCardException(0x69, 0x83);
    }
    if (_pinProvider.pin != YubikitOpenPGP.defaultPin) {
      pinTries -= 1;
      throw const SmartCardException(0x69, 0x82);
    }
  }

  @override
  Future<Uint8List> ecSharedSecret(Uint8List publicKey) async {
    verifyAdminPin();
    if (_encryptionKeyPair == null) {
      throw const SmartCardException(0x69, 0x85);
    }
    final secretKey = await encryptionAlgorithm.sharedSecretKey(
        keyPair: _encryptionKeyPair!,
        remotePublicKey: SimplePublicKey(publicKey, type: KeyPairType.x25519));
    return Uint8List.fromList(await secretKey.extractBytes());
  }

  @override
  Future<Uint8List> generateECKey(KeySlot keySlot, ECCurve curve,
      [int? timestamp]) async {
    verifyAdminPin();
    if (keySlot == KeySlot.encryption) {
      _encryptionKeyPair = await encryptionAlgorithm
          .newKeyPairFromSeed(List.generate(32, (index) => 0x01));
      final seed = await _encryptionKeyPair!.extractPrivateKeyBytes();
      await _preferences.setString(
          mockEncryptionSeedPreference, base64Encode(seed));
      return Uint8List.fromList(
          (await _encryptionKeyPair!.extractPublicKey()).bytes);
    } else if (keySlot == KeySlot.signature) {
      _signingKeyPair = await signingAlgorithm
          .newKeyPairFromSeed(List.generate(32, (index) => 0x02));
      final seed = await _signingKeyPair!.extractPrivateKeyBytes();
      await _preferences.setString(
          mockSigningKeyPreference, base64Encode(seed));
      return Uint8List.fromList(
          (await _signingKeyPair!.extractPublicKey()).bytes);
    }
    throw UnimplementedError();
  }

  @override
  Future<Tuple3<int, int, int>> getApplicationVersion() {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> getECPublicKey(KeySlot keySlot) async {
    if (keySlot == KeySlot.encryption) {
      final bytes = (await _encryptionKeyPair?.extractPublicKey())?.bytes;
      if (bytes != null) {
        return Uint8List.fromList(bytes);
      } else {
        return null;
      }
    } else if (keySlot == KeySlot.signature) {
      final bytes = (await _signingKeyPair?.extractPublicKey())?.bytes;
      if (bytes != null) {
        return Uint8List.fromList(bytes);
      } else {
        return null;
      }
    }
    throw UnimplementedError();
  }

  @override
  Future<Tuple2<int, int>> getOpenPGPVersion() {
    throw UnimplementedError();
  }

  @override
  Future<PinRetries> getRemainingPinTries() async {
    return PinRetries(pinTries, 0, adminPinTries);
  }

  @override
  Future<TouchMode> getTouch(KeySlot keySlot) {
    throw UnimplementedError();
  }

  @override
  Future<void> reset() async {
    pinTries = 3;
    adminPinTries = 3;
    _signingKeyPair = null;
    _encryptionKeyPair = null;
    await _preferences.remove(mockEncryptionSeedPreference);
    await _preferences.remove(mockSigningKeyPreference);
  }

  @override
  Future<void> setPinRetries(int pw1Tries, int pw2Tries, int pw3Tries) {
    throw UnimplementedError();
  }

  @override
  Future<void> setTouch(KeySlot keySlot, TouchMode mode) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> sign(Uint8List data) async {
    verifyPin();
    if (_signingKeyPair == null) {
      throw const SmartCardException(0x69, 0x85);
    }
    final sha512 = Sha512();
    final digest = await sha512.hash(data);
    final signature =
        await signingAlgorithm.sign(digest.bytes, keyPair: _signingKeyPair!);
    return Uint8List.fromList(signature.bytes);
  }
}
