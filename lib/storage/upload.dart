import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/button.dart';
import '../ui/heading.dart';
import '../ui/page.dart';

class Upload extends StatelessWidget with GetItMixin {
  Upload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageWidget(
        child: Center(
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
      ),
    ));
  }
}
