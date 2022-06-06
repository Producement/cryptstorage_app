import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/heading.dart';

class Files extends StatelessWidget with GetItMixin {
  Files(this.files, this.button, {Key? key}) : super(key: key);

  final List<ApiFile> files;
  final Widget button;

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
