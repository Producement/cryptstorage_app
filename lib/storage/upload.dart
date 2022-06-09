import 'dart:convert';
import 'dart:io';

import 'package:age_yubikey_pgp/age_yubikey_pgp.dart';
import 'package:collection/collection.dart';
import 'package:cryptstorage/api/file_service.dart';
import 'package:cryptstorage/api/key_service.dart';
import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:cryptstorage/model/key_model.dart';
import 'package:cryptstorage/storage/files.dart';
import 'package:cryptstorage/ui/loader.dart';
import 'package:dage/dage.dart';
import 'package:file_picker/file_picker.dart';
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
  bool _isUploading = false;

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

          var button = Button(
              title: 'Upload',
              onPressed: () async {
                // TODO: extract to separate class
                try {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setState(() {
                      _isUploading = true;
                    });
                    var platformFile = result.files.single;
                    File file = File(platformFile.path!);
                    var encryptionPublicKey =
                        get<KeyModel>().encryptionPublicKey!;
                    await get<KeyService>()
                        .addEncryptionPublicKeyIfMissing(encryptionPublicKey);
                    List<AgeRecipient> recipients = await getRecipients();
                    var encryptedStream = encrypt(file.openRead(), recipients);
                    var encryptedFile =
                        (await encryptedStream.toList()).flattened.toList();
                    await get<FileService>()
                        .addFile(platformFile.name, encryptedFile);
                    debugPrint('file: $file');
                    await _refreshFiles();
                  } else {
                    debugPrint('user cancelled the filepicker');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()),
                  ));
                  rethrow;
                } finally {
                  setState(() {
                    _isUploading = false;
                  });
                }
              });

          return RefreshIndicator(
            onRefresh: _refreshFiles,
            child: !_isUploading
                ? files(snapshot, button)
                : const CircularProgressIndicator(),
          );
        },
      ),
    ));
  }

  Future<List<AgeRecipient>> getRecipients() async {
    var keys = await get<KeyService>().getKeys();
    var encryptionKeys = keys.where((key) => key.use == JwkUse.enc);
    if (encryptionKeys.isEmpty) {
      throw Exception('No encryption keys found');
    }
    var recipients = encryptionKeys
        .map((key) => AgeRecipient(
            YubikeyPgpX25519AgePlugin.publicKeyPrefix, base64Decode(key.x)))
        .toList();
    return recipients;
  }

  StatelessWidget files(AsyncSnapshot<List<ApiFile>> snapshot, Button button) {
    return snapshot.data?.isEmpty ?? true
        ? NoFiles(button)
        : Files(snapshot.data!, button);
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
