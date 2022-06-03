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
    return (await _openApi.filesPost(filename: fileName, file: file)).body!;
  }
}
