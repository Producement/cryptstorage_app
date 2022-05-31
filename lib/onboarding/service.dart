import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:dage/dage.dart';
import 'package:get_it/get_it.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class OnboardingService {
  final SmartCardService _smartCardService;
  final KeyModel _keyModel;

  OnboardingService({SmartCardService? smartCardService, KeyModel? keyModel})
      : _smartCardService = smartCardService ?? GetIt.I.get(),
        _keyModel = keyModel ?? GetIt.I.get();

  Future<bool> fetchKeyInfo() async {
    _keyModel.reset();
    final signaturePublicKey =
        await _smartCardService.getECPublicKey(KeySlot.signature);
    final encryptionPublicKey =
        await _smartCardService.getECPublicKey(KeySlot.encryption);
    if (signaturePublicKey != null) {
      _keyModel.signaturePublicKey = signaturePublicKey;
    }
    if (encryptionPublicKey != null) {
      _keyModel.addRecipient(AgeRecipient(
          YubikeyPgpX2559AgePlugin.publicKeyPrefix, encryptionPublicKey));
    }
    return _keyModel.isKeyInitialised;
  }

  Future<bool> generate() async {
    if (_keyModel.signaturePublicKey == null) {
      final signingPublicKey = await _smartCardService.generateECKey(
          KeySlot.signature, ECCurve.ed25519);
      _keyModel.signaturePublicKey = signingPublicKey;
    }
    if (_keyModel.getRecipients.isEmpty) {
      final publicKey = await _smartCardService.generateECKey(
          KeySlot.encryption, ECCurve.x25519);
      final encryptionPublicKey =
          AgeRecipient(YubikeyPgpX2559AgePlugin.publicKeyPrefix, publicKey);
      _keyModel.addRecipient(encryptionPublicKey);
    }
    return _keyModel.isKeyInitialised;
  }
}
