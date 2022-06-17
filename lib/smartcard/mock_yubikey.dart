import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:get_it/get_it.dart';
import 'package:jwk/jwk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class MockYubikitOpenPGP implements YubikitOpenPGP {
  static const mockSigningKeyPreference = 'mockSigningKey';
  static const mockEncryptionKeyPreference = 'mockEncryptionKey';
  final PinProvider _pinProvider;
  final SharedPreferences _preferences;
  static final signingAlgorithm = Ed25519();
  static final encryptionAlgorithm = X25519();
  KeyPair? _signingKeyPair;
  KeyPair? _encryptionKeyPair;
  int pinTries = 3, adminPinTries = 3;

  MockYubikitOpenPGP({PinProvider? pinProvider, SharedPreferences? preferences})
      : _pinProvider = pinProvider ?? GetIt.I.get(),
        _preferences = preferences ?? GetIt.I.get() {
    _signingKeyPair = _deserialize(_preferences, mockSigningKeyPreference);
    _encryptionKeyPair =
        _deserialize(_preferences, mockEncryptionKeyPreference);
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
  Future<Uint8List> ecSharedSecret(List<int> publicKey) async {
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
  Future<ECKeyData> generateECKey(KeySlot keySlot, ECCurve curve,
      [int? timestamp]) async {
    verifyAdminPin();
    if (keySlot == KeySlot.encryption) {
      final encryptionKeyPair = await encryptionAlgorithm
          .newKeyPairFromSeed(List.generate(32, (index) => 0x01));
      _encryptionKeyPair = encryptionKeyPair;
      _serialize(mockEncryptionKeyPreference, encryptionKeyPair);
      final response = (await encryptionKeyPair.extractPublicKey()).bytes;
      return ECKeyData(response, keySlot);
    } else if (keySlot == KeySlot.signature) {
      final signingKeyPair = await signingAlgorithm
          .newKeyPairFromSeed(List.generate(32, (index) => 0x02));
      _signingKeyPair = signingKeyPair;
      _serialize(mockSigningKeyPreference, signingKeyPair);
      final response = (await signingKeyPair.extractPublicKey()).bytes;
      return ECKeyData(response, keySlot);
    }
    throw UnimplementedError();
  }

  void _serialize(String key, KeyPair keyPair) {
    final jwk = Jwk.fromKeyPair(keyPair);
    _preferences.setString(key, json.encode(jwk.toJson()));
  }

  static KeyPair? _deserialize(SharedPreferences preferences, String key) {
    final jwk = preferences.getString(key);
    if (jwk == null) {
      return null;
    }
    return Jwk.fromJson(json.decode(jwk)).toKeyPair();
  }

  @override
  Future<KeyData?> getPublicKey(KeySlot keySlot) async {
    if (keySlot == KeySlot.encryption) {
      final pubKey = await _encryptionKeyPair?.extractPublicKey();
      if (pubKey is RsaPublicKey) {
        return RSAKeyData(pubKey.n, pubKey.e, keySlot);
      } else if (pubKey is SimplePublicKey) {
        return ECKeyData(pubKey.bytes, keySlot);
      } else {
        return null;
      }
    } else if (keySlot == KeySlot.signature) {
      final pubKey = await _signingKeyPair?.extractPublicKey();
      if (pubKey is RsaPublicKey) {
        return RSAKeyData(pubKey.n, pubKey.e, keySlot);
      } else if (pubKey is SimplePublicKey) {
        return ECKeyData(pubKey.bytes, keySlot);
      } else {
        return null;
      }
    }
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
    await _preferences.remove(mockEncryptionKeyPreference);
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
  Future<Uint8List> ecSign(List<int> data) async {
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

  @override
  Future<RSAKeyData> generateRSAKey(KeySlot keySlot, int keySize,
      [int? timestamp]) async {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> rsaSign(List<int> data) async {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> decipher(List<int> ciphertext) {
    throw UnimplementedError();
  }

  @override
  Future<ApplicationVersion> getApplicationVersion() {
    throw UnimplementedError();
  }

  @override
  Future<OpenPGPVersion> getOpenPGPVersion() {
    throw UnimplementedError();
  }
}
