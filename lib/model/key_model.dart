import 'dart:convert';
import 'dart:typed_data';

import 'package:dage/dage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyModel extends ChangeNotifier {
  static const signaturePublicKeyPref = 'signaturePublicKey';
  static const encryptionRecipientsPref = 'encryptionRecipients';
  Uint8List? _signaturePublicKey;
  List<AgeRecipient> _encryptionRecipients = [];
  final SharedPreferences _prefs;

  KeyModel({SharedPreferences? prefs}) : _prefs = prefs ?? GetIt.I.get() {
    final signaturePublicKey = _prefs.getString(signaturePublicKeyPref);
    if (signaturePublicKey != null) {
      _signaturePublicKey = base64Decode(signaturePublicKey);
    }
    _encryptionRecipients = _prefs
            .getStringList(encryptionRecipientsPref)
            ?.map((e) => AgeRecipient.fromBech32(e))
            .toList() ??
        [];
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

  Uint8List? get signaturePublicKey => _signaturePublicKey;

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
      _signaturePublicKey != null && _encryptionRecipients.isNotEmpty;

  void reset() {
    _signaturePublicKey = null;
    _encryptionRecipients.clear();
    notifyListeners();
  }
}
