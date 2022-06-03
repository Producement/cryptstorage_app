import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/files.dart';
import 'package:cryptstorage/ui/loader.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/error.dart' as ui;
import '../ui/heading.dart';
import '../ui/page.dart';

class Upload extends StatelessWidget with GetItMixin {
  Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
      child: FutureBuilder<List<ApiFile>>(
        future: _getFiles(),
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ui.Error(
                error: snapshot.error!, stackTrace: snapshot.stackTrace);
          }
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return RefreshIndicator(
              onRefresh: () => _getFiles(),
              child: snapshot.data?.isEmpty ?? true
                  ? const NoFiles()
                  : Files(snapshot.data!));
        },
      ),
    ));
  }

  Future<List<ApiFile>> _getFiles() async {
    return get<FileService>().getFiles();
  }
}

class NoFiles extends StatelessWidget {
  const NoFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
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
                  Button(title: 'Upload', onPressed: () {}),
                ],
              ))),
    );
  }
}
