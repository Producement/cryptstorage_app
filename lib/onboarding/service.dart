import 'package:cryptstorage/injection.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:logging/logging.dart';
import 'package:yubikit_flutter/yubikit_flutter.dart';

class OnboardingService {
  final logger = Logger('OnboardingService');
  final SmartCardService _smartCardService;
  final KeyModel _keyModel;

  OnboardingService({SmartCardService? smartCardService, KeyModel? keyModel})
      : _smartCardService = smartCardService ?? getIt(),
        _keyModel = keyModel ?? getIt();

  Future<bool> fetchKeyInfo() async {
    logger.info('Fetching key info');
    _keyModel.reset();
    final keys = await _smartCardService.getAllPublicKeys();
    final signaturePublicKey = keys[KeySlot.signature];
    final encryptionPublicKey = keys[KeySlot.encryption];
    if (signaturePublicKey != null) {
      logger.info('Signature key present');
      _keyModel.signaturePublicKey = signaturePublicKey.toJwk();
    }
    if (encryptionPublicKey != null) {
      logger.info('Encryption key present');
      _keyModel.encryptionPublicKey = encryptionPublicKey.toJwk();
    }
    return _keyModel.isKeyInitialised;
  }

  Future<bool> generateMissingKeys() async {
    final slots = <MapEntry<KeySlot, ECCurve>>[
      ...(_keyModel.signaturePublicKey == null
          ? [const MapEntry(KeySlot.signature, ECCurve.ed25519)]
          : []),
      ...(_keyModel.encryptionPublicKey == null
          ? [const MapEntry(KeySlot.encryption, ECCurve.x25519)]
          : [])
    ];
    logger.info('Missing keys $slots');
    final results =
        await _smartCardService.generateECKeys(Map.fromEntries(slots));
    if (results.containsKey(KeySlot.signature)) {
      logger.info('Generated signature key');
      final signaturePublicKey = results[KeySlot.signature]!;
      _keyModel.signaturePublicKey = signaturePublicKey.toJwk();
    }
    if (results.containsKey(KeySlot.encryption)) {
      logger.info('Generated encryption key');
      final encryptionPublicKey = results[KeySlot.encryption]!;
      _keyModel.encryptionPublicKey = encryptionPublicKey.toJwk();
    }
    return _keyModel.isKeyInitialised;
  }
}
