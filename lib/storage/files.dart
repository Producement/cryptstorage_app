import 'package:cryptstorage/generated/openapi.swagger.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Files extends StatelessWidget with GetItMixin {
  Files(this.files, {Key? key}) : super(key: key);
  final List<ApiFile> files;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
    );
  }
}
