import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:collection/collection.dart';
import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/api/key_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:dage/dage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:logging/logging.dart';

class FileUploader {
  final logger = Logger('FileUploader');
  final KeyModel _keyModel;
  final KeyService _keyService;
  final FileService _fileService;

  FileUploader(this._keyModel, this._keyService, this._fileService);

  Future<void> pickEncryptAndUploadFile() async {
    var filePickerResult = await FilePicker.platform.pickFiles();

    if (filePickerResult != null) {
      final platformFile = filePickerResult.files.single;
      File file = File(platformFile.path!);
      logger.fine('Picked file: $file');
      final encryptionPublicKey = _keyModel.encryptionPublicKey!;
      await _keyService.addEncryptionPublicKeyIfMissing(encryptionPublicKey);
      List<AgeRecipient> recipients = await _getRecipients();
      logger.info('Recipients: ${recipients.length}');
      final encryptedStream = encrypt(file.openRead(), recipients);
      final encryptedFile = (await encryptedStream.toList()).flattened.toList();
      await _fileService.addFile(platformFile.name, encryptedFile);
    }
  }

  Future<List<AgeRecipient>> _getRecipients() async {
    final keys = await _keyService.getKeys();
    final encryptionKeys = keys.where((key) => key.use == JwkUse.enc);
    logger.info(encryptionKeys);
    if (encryptionKeys.isEmpty) {
      throw Exception('No encryption keys found');
    }
    final ellipticKeys = encryptionKeys.whereType<EllipticJwk>();
    final ellipticRecipients = ellipticKeys
        .map((key) => AgeRecipient(
            YubikeyPgpX25519AgePlugin.publicKeyPrefix, base64Decode(key.x)))
        .toList();
    final rsaKeys = encryptionKeys.whereType<RsaJwk>();
    final rsaRecipients = rsaKeys
        .map((key) => _parseRecipient(base64Decode(key.n), base64Decode(key.e)))
        .toList();
    return ellipticRecipients + rsaRecipients;
  }

  AgeRecipient _parseRecipient(List<int> modulus, List<int> exponent) {
    return AgeRecipient(
        YubikeyPgpRsaAgePlugin.publicKeyPrefix,
        Uint8List.fromList([
          modulus.length >> 8,
          modulus.length & 0xFF,
          ...modulus,
          ...exponent
        ]));
  }
}
