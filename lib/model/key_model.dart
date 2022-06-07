import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptstorage/injection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyModel extends ChangeNotifier {
  static const signaturePublicKeyPref = 'signaturePublicKey';
  static const encryptionPublicKeyPref = 'encryptionPublicKey';
  Uint8List? _signaturePublicKey;
  Uint8List? _encryptionPublicKey;
  final SharedPreferences _prefs;

  KeyModel({SharedPreferences? prefs}) : _prefs = prefs ?? getIt() {
    final signaturePublicKey = _prefs.getString(signaturePublicKeyPref);
    if (signaturePublicKey != null) {
      _signaturePublicKey = base64Decode(signaturePublicKey);
    }
    final encryptionPublicKey = _prefs.getString(encryptionPublicKeyPref);
    if (encryptionPublicKey != null) {
      _encryptionPublicKey = base64Decode(encryptionPublicKey);
    }
  }

  set signaturePublicKey(Uint8List? signaturePublicKey) {
    _signaturePublicKey = signaturePublicKey;
    if (signaturePublicKey != null) {
      _prefs.setString(
          signaturePublicKeyPref, base64Encode(signaturePublicKey));
    } else {
      _prefs.remove(signaturePublicKeyPref);
    }
    notifyListeners();
  }

  set encryptionPublicKey(Uint8List? encryptionPublicKey) {
    _encryptionPublicKey = encryptionPublicKey;
    if (encryptionPublicKey != null) {
      _prefs.setString(
          encryptionPublicKeyPref, base64Encode(encryptionPublicKey));
    } else {
      _prefs.remove(encryptionPublicKeyPref);
    }
    notifyListeners();
  }

  Uint8List? get signaturePublicKey => _signaturePublicKey;

  Uint8List? get encryptionPublicKey => _encryptionPublicKey;

  bool get isKeyInitialised =>
      _signaturePublicKey != null && _encryptionPublicKey != null;

  void reset() {
    _signaturePublicKey = null;
    _encryptionPublicKey = null;
    notifyListeners();
  }
}
