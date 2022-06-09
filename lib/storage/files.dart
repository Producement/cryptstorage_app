import 'dart:io';

import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/heading.dart';

class Files extends StatelessWidget with GetItMixin {
  Files(this.files, this.button, {Key? key}) : super(key: key);

  final List<ApiFile> files;
  final Widget button;
  final httpClient = HttpClient(); // TODO: how to Dependency Inject instead?

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                    leading: const Icon(Icons.image),
                title: Text(files[index].name,
                    style: const TextStyle(color: Colors.black87)),
                onTap: () async {
                  // TODO: extract to separate class
                  var request =
                      await httpClient.getUrl(Uri.parse(files[index].url));
                  var response = await request.close();
                  var bytes =
                      await consolidateHttpClientResponseBytes(response);
                  bool status = await Permission.storage.isGranted;
                  if (!status) await Permission.storage.request();
                  Directory? directory;
                  if (Platform.isAndroid) {
                    directory = Directory('/storage/emulated/0/Download');
                  } else if (Platform.isIOS) {
                    directory = await getApplicationDocumentsDirectory();
                  }
                  var dir = directory!.path;
                  var path = '$dir/${files[index].name}';
                  debugPrint('Saving file to: $path');
                  File file = File(path);
                  await file.writeAsBytes(bytes);
                },
                trailing: const Icon(Icons.delete),
              ));
            },
          ),
        ),
        button,
      ],
    );
  }
}

class NoFiles extends StatelessWidget {
  const NoFiles(this.button, {
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
