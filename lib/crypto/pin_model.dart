import 'package:flutter/material.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:yubikit_openpgp/smartcard/pin_provider.dart';

class PinModel extends ChangeNotifier implements PinProvider {
  String _pin = YubikitOpenPGP.defaultPin,
      _adminPin = YubikitOpenPGP.defaultAdminPin;

  set pin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  @override
  String get pin => _pin;

  set adminPin(String adminPin) {
    _adminPin = adminPin;
    notifyListeners();
  }

  @override
  String get adminPin => _adminPin;

  void reset() {
    _pin = YubikitOpenPGP.defaultPin;
    _adminPin = YubikitOpenPGP.defaultAdminPin;
    notifyListeners();
  }
}
