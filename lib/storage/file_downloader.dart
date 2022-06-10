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
    final fileBytes = await downloadFile(apiFile);
    bool status = await Permission.storage.isGranted;
    if (!status) await Permission.storage.request();
    String directory = await _getSaveDirectory();
    var path = '$directory/${apiFile.name}';
    debugPrint('Saving file to: $path');
    File file = File(path);
    await file.writeAsBytes(fileBytes);
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
    var response = await _httpClient.get(Uri.parse(apiFile.url));
    return response.bodyBytes;
  }
}
