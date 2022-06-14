import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:open_file/open_file.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/heading.dart';

class Files extends StatelessWidget with GetItMixin {
  Files(this._files, this._button, {Key? key}) : super(key: key);

  final List<ApiFile> _files;
  final Widget _button;

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

  Future<void> _handleDownload(
      ApiFile currentFile, BuildContext context) async {
    try {
      final filePath =
          await get<FileDownloader>().downloadDecryptAndCacheFile(currentFile);
      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      rethrow;
    }
  }

  Future<void> _handleDelete(ApiFile currentFile, BuildContext context) async {
    debugPrint('Handling delete...');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Handing delete...'),
    ));
  }
}

class NoFiles extends StatelessWidget {
  const NoFiles(
    this.button, {
    Key? key,
  }) : super(key: key);

  final Widget button;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        ExclamationImage(),
                        Heading(title: 'Folder is Empty'),
                        Body(text: 'Secure your files by uploading them here'),
                      ],
                    ),
                    button,
                  ],
                )));
      },
    );
  }
}
