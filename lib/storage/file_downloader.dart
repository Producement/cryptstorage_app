import 'dart:io';

import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:collection/collection.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/smartcard/smartcard_service.dart';
import 'package:dage/dage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  final http.Client _httpClient;
  final SmartCardService _smartCardService;

  FileDownloader(this._httpClient, this._smartCardService);

  Future<String> downloadAndSaveFile(ApiFile apiFile) async {
    final fileBytes = await downloadFile(apiFile);
    final bool status = await Permission.storage.isGranted;
    if (!status) await Permission.storage.request();
    final String directory = await _getSaveDirectory();
    final path = '$directory/${apiFile.name}';
    debugPrint('Saving file to: $path');
    final File file = File(path);
    await file.writeAsBytes(fileBytes);
    return path;
  }

  Future<String> downloadDecryptAndCacheFile(ApiFile apiFile) async {
    final encryptedFile = await downloadFile(apiFile);
    final recipientFromCard =
        await YubikeyPgpX25519AgePlugin.fromCard(_smartCardService) ??
            await YubikeyPgpRsaAgePlugin.fromCard(_smartCardService);
    if (recipientFromCard == null) {
      throw Exception('No recipient found');
    }
    final decrypted =
        decrypt(Stream.value(encryptedFile), [recipientFromCard.asKeyPair()]);
    final decryptedBytes = (await decrypted.toList()).flattened.toList();

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/${apiFile.name}';
    debugPrint('Saving file to: $path');
    final File file = File(path);
    await file.writeAsBytes(decryptedBytes);
    return path;
  }

  Future<String> _getSaveDirectory() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    return directory!.path;
  }

  Future<List<int>> downloadFile(ApiFile apiFile) async {
    final response = await _httpClient.get(Uri.parse(apiFile.url));
    return response.bodyBytes;
  }
}
