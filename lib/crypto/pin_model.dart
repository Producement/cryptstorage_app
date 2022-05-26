import 'package:flutter/material.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class PinModel extends ChangeNotifier {
  String _pin = YubikitOpenPGP.defaultPin,
      _adminPin = YubikitOpenPGP.defaultAdminPin;

  set pin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  String get pin => _pin;

  set adminPin(String adminPin) {
    _adminPin = adminPin;
    notifyListeners();
  }

  String get adminPin => _adminPin;

  void reset() {
    _pin = YubikitOpenPGP.defaultPin;
    _adminPin = YubikitOpenPGP.defaultAdminPin;
    notifyListeners();
  }
}
