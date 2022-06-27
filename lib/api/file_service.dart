import 'package:get_it/get_it.dart';

import '../generated/openapi.swagger.dart';

class FileService {
  final Openapi _openApi;

  FileService({
    Openapi? openApi,
  }) : _openApi = openApi ?? GetIt.I.get();

  Future<List<ApiFile>> getFiles() async {
    return (await _openApi.filesGet()).body ?? [];
  }

  Future<ApiFile> addFile(String fileName, List<int> file) async {
    final response = await _openApi.filesPost(filename: fileName, file: file);
    if (!response.isSuccessful) {
      throw Exception(
          'Adding the file failed: ${response.statusCode} ${response.error}');
    }
    return response.body!;
  }

  Future<void> deleteFile(String fileId) async {
    await _openApi.filesIdDelete(id: fileId);
  }
}
