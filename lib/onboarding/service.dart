import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:get_it/get_it.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class OnboardingService {
  final YubikitOpenPGP _interface;
  final KeyModel _keyModel;

  OnboardingService({YubikitOpenPGP? interface, KeyModel? keyModel})
      : _interface = interface ?? GetIt.I.get(),
        _keyModel = keyModel ?? GetIt.I.get();

  Future<bool> fetchKeyInfo() async {
    _keyModel.reset();
    final signaturePublicKey =
        await _interface.getECPublicKey(KeySlot.signature);
    final encryptionKey = await YubikeyPgpX2559AgePlugin.fromCard(_interface);
    if (signaturePublicKey != null) {
      _keyModel.signaturePublicKey = signaturePublicKey;
    }
    if (encryptionKey != null) {
      _keyModel.addRecipient(encryptionKey);
    }
    return _keyModel.isKeyInitialised;
  }

  Future<bool> generate() async {
    if (_keyModel.signaturePublicKey == null) {
      final signingPublicKey =
          await _interface.generateECKey(KeySlot.signature, ECCurve.ed25519);
      _keyModel.signaturePublicKey = signingPublicKey;
    }
    if (_keyModel.getRecipients.isEmpty) {
      final encryptionPublicKey =
          await YubikeyPgpX2559AgePlugin.generate(_interface);
      _keyModel.addRecipient(encryptionPublicKey);
    }
    return _keyModel.isKeyInitialised;
  }
}
