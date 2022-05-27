import 'dart:typed_data';

import 'package:dage/dage.dart';
import 'package:flutter/material.dart';

class KeyModel extends ChangeNotifier {
  Uint8List? _signingPublicKey;
  final List<AgeRecipient> _encryptionRecipients = [];

  set signingPublicKey(Uint8List? signingPublicKey) {
    _signingPublicKey = signingPublicKey;
    notifyListeners();
  }

  Uint8List? get signingPublicKey => _signingPublicKey;

  void addRecipient(AgeRecipient recipient) {
    _encryptionRecipients.add(recipient);
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
