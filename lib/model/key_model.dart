import 'dart:convert';
import 'dart:typed_data';

import 'package:dage/dage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyModel extends ChangeNotifier {
  static const signingPublicKeyPref = 'signingPublicKey';
  static const encryptionRecipientsPref = 'encryptionRecipients';
  Uint8List? _signingPublicKey;
  List<AgeRecipient> _encryptionRecipients = [];
  final SharedPreferences _prefs;

  KeyModel(this._prefs) {
    final signingPublicKey = _prefs.getString(signingPublicKeyPref);
    if (signingPublicKey != null) {
      _signingPublicKey = base64Decode(signingPublicKey);
    }
    _encryptionRecipients = _prefs
            .getStringList(encryptionRecipientsPref)
            ?.map((e) => AgeRecipient.fromBech32(e))
            .toList() ??
        [];
  }

  set signingPublicKey(Uint8List? signingPublicKey) {
    _signingPublicKey = signingPublicKey;
    if (signingPublicKey != null) {
      _prefs.setString(signingPublicKeyPref, base64Encode(signingPublicKey));
    } else {
      _prefs.remove(signingPublicKeyPref);
    }
    notifyListeners();
  }

  Uint8List? get signingPublicKey => _signingPublicKey;

  void addRecipient(AgeRecipient recipient) {
    _encryptionRecipients.add(recipient);
    _prefs.setStringList(
        encryptionRecipientsPref,
        _encryptionRecipients
            .map((recipient) => recipient.toString())
            .toList());
    notifyListeners();
  }

  List<AgeRecipient> get getRecipients => _encryptionRecipients;

  bool get isKeyInitialised =>
      _signingPublicKey != null && _encryptionRecipients.isNotEmpty;

  void reset() {
    _signingPublicKey = null;
    _encryptionRecipients.clear();
    notifyListeners();
  }
}
