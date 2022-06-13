import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/file_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:open_file/open_file.dart';

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
                leading: const Icon(Icons.image),
                title: Text(currentFile.name,
                    style: const TextStyle(color: Colors.black87)),
                onTap: () async {
                  final filePath = await get<FileDownloader>()
                      .downloadDecryptAndCacheFile(currentFile);
                  final result = await OpenFile.open(filePath);
                  debugPrint(
                      'OpenFile result: ${result.type}, ${result.message}');
                },
                trailing: const Icon(Icons.delete),
              ));
            },
          ),
        ),
        _button,
      ],
    );
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
