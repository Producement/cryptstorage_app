import 'dart:io';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloader {
  final http.Client _httpClient;

  FileDownloader(this._httpClient);

  void downloadAndSaveFile(ApiFile apiFile) async {
    var response = await _httpClient.get(Uri.parse(apiFile.url));
    var bytes = response.bodyBytes;
    bool status = await Permission.storage.isGranted;
    if (!status) await Permission.storage.request();
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    var dir = directory!.path;
    var path = '$dir/${apiFile.name}';
    debugPrint('Saving file to: $path');
    File file = File(path);
    await file.writeAsBytes(bytes);
  }
}
