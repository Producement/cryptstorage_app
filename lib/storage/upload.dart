import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/storage/file_uploader.dart';
import 'package:cryptstorage/storage/files.dart';
import 'package:cryptstorage/storage/no_files.dart';
import 'package:cryptstorage/ui/loader.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../ui/button.dart';
import '../ui/error.dart' as ui;
import '../ui/page.dart';

class Upload extends StatefulWidget with GetItStatefulWidgetMixin {
  Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> with GetItStateMixin {
  late Future<List<ApiFile>> _files;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _files = _getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
      child: FutureBuilder<List<ApiFile>>(
        future: _files,
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

          final button = Button(
              title: 'Upload',
              onPressed: () async {
                try {
                  _setLoading(true);
                  await get<FileUploader>().pickEncryptAndUploadFile();
                  await _refreshFiles();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                  rethrow;
                } finally {
                  _setLoading(false);
                }
              });

          return RefreshIndicator(
            onRefresh: _refreshFiles,
            child: !_isLoading
                ? _filesWidget(snapshot, button, _refreshFiles, _setLoading)
                : const CircularProgressIndicator(),
          );
        },
      ),
    ));
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  StatelessWidget _filesWidget(
      AsyncSnapshot<List<ApiFile>> snapshot,
      Button button,
      Future<void> Function() refreshFiles,
      void Function(bool isLoading) setLoading) {
    return snapshot.data?.isEmpty ?? true
        ? NoFiles(button)
        : Files(snapshot.data!, button, refreshFiles, setLoading);
  }

  Future<void> _refreshFiles() async {
    setState(() {
      _files = _getFiles();
    });
  }

  Future<List<ApiFile>> _getFiles() async {
    return get<FileService>().getFiles();
  }
}
