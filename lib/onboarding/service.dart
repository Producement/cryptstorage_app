import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class OnboardingService {
  final YubikitOpenPGP _interface;
  final KeyModel _keyModel;

  const OnboardingService(this._interface, this._keyModel);

  Future<bool> fetchKeyInfo() async {
    _keyModel.reset();
    final signingPublicKey = await _interface.getECPublicKey(KeySlot.signature);
    final encryptionKey = await YubikeyPgpX2559AgePlugin.fromCard(_interface);
    if (signingPublicKey != null) {
      _keyModel.signingPublicKey = signingPublicKey;
    }
    if (encryptionKey != null) {
      _keyModel.addRecipient(encryptionKey);
    }
    return _keyModel.isKeyInitialised;
  }

  Future<bool> generate() async {
    if (_keyModel.signingPublicKey == null) {
      final signingPublicKey =
          await _interface.generateECKey(KeySlot.signature, ECCurve.ed25519);
      _keyModel.signingPublicKey = signingPublicKey;
    }
    if (_keyModel.getRecipients.isEmpty) {
      final encryptionPublicKey =
          await YubikeyPgpX2559AgePlugin.generate(_interface);
      _keyModel.addRecipient(encryptionPublicKey);
    }
    return _keyModel.isKeyInitialised;
  }
}
