import 'dart:convert';

import 'package:cryptstorage/injection.dart';
import 'package:flutter/material.dart';
import 'package:jwk/jwk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyModel extends ChangeNotifier {
  static const signaturePublicKeyPref = 'signaturePublicKey';
  static const encryptionPublicKeyPref = 'encryptionPublicKey';
  Jwk? _signaturePublicKey;
  Jwk? _encryptionPublicKey;
  final SharedPreferences _prefs;

  KeyModel({SharedPreferences? prefs}) : _prefs = prefs ?? getIt() {
    final signaturePublicKey = _prefs.getString(signaturePublicKeyPref);
    if (signaturePublicKey != null) {
      _signaturePublicKey = Jwk.fromJson(json.decode(signaturePublicKey));
    }
    final encryptionPublicKey = _prefs.getString(encryptionPublicKeyPref);
    if (encryptionPublicKey != null) {
      _encryptionPublicKey = Jwk.fromJson(json.decode(encryptionPublicKey));
    }
  }

  set signaturePublicKey(Jwk? signaturePublicKey) {
    _signaturePublicKey = signaturePublicKey;
    if (signaturePublicKey != null) {
      _prefs.setString(
          signaturePublicKeyPref, json.encode(signaturePublicKey.toJson()));
    } else {
      _prefs.remove(signaturePublicKeyPref);
    }
    notifyListeners();
  }

  set encryptionPublicKey(Jwk? encryptionPublicKey) {
    _encryptionPublicKey = encryptionPublicKey;
    if (encryptionPublicKey != null) {
      _prefs.setString(
          encryptionPublicKeyPref, json.encode(encryptionPublicKey.toJson()));
    } else {
      _prefs.remove(encryptionPublicKeyPref);
    }
    notifyListeners();
  }

  Jwk? get signaturePublicKey => _signaturePublicKey;

  Jwk? get encryptionPublicKey => _encryptionPublicKey;

  bool get isKeyInitialised =>
      _signaturePublicKey != null && _encryptionPublicKey != null;

  void reset() {
    _signaturePublicKey = null;
    _encryptionPublicKey = null;
    notifyListeners();
  }
}
