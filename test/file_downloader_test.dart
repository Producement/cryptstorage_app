import 'dart:convert';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/file_downloader.dart';
import 'package:test/test.dart';

import 'mock_client.dart';
import 'token_service.mocks.dart';

void main() {
  final fileDownloader = FileDownloader(mockClient, MockSmartCardService());

  test('download file', () async {
    final apiFile = ApiFile(
        id: 'uuid',
        name: 'filename.txt',
        url: 'https://s3/filename.txt',
        createdAt: DateTime.now());

    var fileBytes = await fileDownloader.downloadFile(apiFile);

    expect(utf8.decode(fileBytes), equals('file content'));
  });
}
