import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:open_file/open_file.dart';
import 'package:timeago/timeago.dart' as timeago;

class Files extends StatelessWidget with GetItMixin {
  Files(this._files, this._button, this._refreshFiles, this._setLoading,
      {Key? key})
      : super(key: key);

  final List<ApiFile> _files;
  final Widget _button;
  final Future<void> Function() _refreshFiles;
  final void Function(bool isLoading) _setLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: (context, index) {
              var currentFile = _files[index];
              return Card(
                  child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.article),
                        ],
                      ),
                      title: Text(currentFile.name,
                          style: const TextStyle(color: Colors.black87)),
                      subtitle: Text(timeago.format(currentFile.createdAt),
                          style: const TextStyle(color: Colors.black38)),
                      onTap: () async =>
                      await _handleDownload(currentFile, context),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(Icons.file_download),
                                  title: const Text('Download',
                                      style: TextStyle(color: Colors.black87)),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await _handleDownload(currentFile, context);
                                  },
                                ),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete',
                                      style: TextStyle(color: Colors.black87)),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await _handleDelete(currentFile, context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      )));
            },
          ),
        ),
        _button,
      ],
    );
  }

  Future<void> _handleDownload(ApiFile currentFile, BuildContext context) async {
    try {
      debugPrint('Handling download...');
      _setLoading(true);
      final filePath =
          await get<FileDownloader>().downloadDecryptAndCacheFile(currentFile);
      await OpenFile.open(filePath);
      _setLoading(false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      rethrow;
    }
  }

  Future<void> _handleDelete(ApiFile file, BuildContext context) async {
    try {
      debugPrint('Handling delete...');
      _setLoading(true);
      await get<FileService>().deleteFile(file.id);
      debugPrint('Refreshing files...');
      await _refreshFiles();
      _setLoading(false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      rethrow;
    }
  }
}
