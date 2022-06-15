import 'package:flutter/material.dart';

import '../images/exclamation.dart';
import '../ui/body.dart';
import '../ui/heading.dart';

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
