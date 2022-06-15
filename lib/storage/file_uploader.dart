import 'dart:convert';
import 'dart:io';

import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:collection/collection.dart';
import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/api/key_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:dage/dage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploader {
  final KeyModel _keyModel;
  final KeyService _keyService;
  final FileService _fileService;

  FileUploader(this._keyModel, this._keyService, this._fileService);

  Future<void> pickEncryptAndUploadFile() async {
    var filePickerResult = await FilePicker.platform.pickFiles();

    if (filePickerResult != null) {
      var platformFile = filePickerResult.files.single;
      File file = File(platformFile.path!);
      debugPrint('Picked file: $file');
      var encryptionPublicKey = _keyModel.encryptionPublicKey!;
      await _keyService.addEncryptionPublicKeyIfMissing(encryptionPublicKey);
      List<AgeRecipient> recipients = await _getRecipients();
      var encryptedStream = encrypt(file.openRead(), recipients);
      var encryptedFile = (await encryptedStream.toList()).flattened.toList();
      await _fileService.addFile(platformFile.name, encryptedFile);
    }
  }

  Future<List<AgeRecipient>> _getRecipients() async {
    var keys = await _keyService.getKeys();
    var encryptionKeys =
        keys.where((key) => key.use == JwkUse.enc).whereType<EllipticJwk>();
    if (encryptionKeys.isEmpty) {
      throw Exception('No encryption keys found');
    }
    var recipients = encryptionKeys
        .map((key) => AgeRecipient(
            YubikeyPgpX25519AgePlugin.publicKeyPrefix, base64Decode(key.x)))
        .toList();
    return recipients;
  }
}
